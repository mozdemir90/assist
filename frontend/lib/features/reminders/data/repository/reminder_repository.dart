import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/core/local_db/app_database.dart';
import 'package:frontend/core/local_db/daos/reminders_dao.dart';
import '../remote/reminder_api_service.dart';
import '../../domain/reminder_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'reminder_repository.g.dart';

class ReminderRepository {
  final RemindersDao _localDb;
  final ReminderApiService _apiService;

  ReminderRepository(this._localDb, this._apiService);

  Future<List<ReminderModel>> getReminders() async {
    final localReminders = await _localDb.getAllReminders();
    return localReminders
        .map((e) => ReminderModel(
              id: e.id,
              title: e.title,
              message: e.message,
              triggerTime: e.triggerTime,
              isSent: e.isSent,
              taskId: e.taskId,
              activityId: e.activityId,
              userId: e.userId,
            ))
        .toList();
  }

  Future<void> fetchAndSyncReminders() async {
    try {
      final localReminders = await _localDb.getAllRemindersForSync();

      for (final localReminder in localReminders) {
        if (localReminder.syncStatus == 'pending_insert' || localReminder.syncStatus == 'pending_update') {
          try {
            if (localReminder.syncStatus == 'pending_insert') {
              await _apiService.createReminder({
                'title': localReminder.title,
                'trigger_time': localReminder.triggerTime.toUtc().toIso8601String(),
                'message': localReminder.message,
                if (localReminder.taskId != null) 'task_id': localReminder.taskId,
                if (localReminder.activityId != null) 'activity_id': localReminder.activityId,
              });
            } else {
              // Reminder API might not have an update endpoint, but if it did it would go here.
              // We'll skip put for now as reminders are usually just created/deleted.
            }
            await _localDb.updateReminder(localReminder.copyWith(syncStatus: 'synced'));
          } catch (e) {
            print('Failed to push pending reminder \${localReminder.id}: \$e');
          }
        }
      }

      final remoteReminders = await _apiService.getReminders();
      for (final remoteReminder in remoteReminders) {
        final localReminder = localReminders.cast<ReminderEntity?>().firstWhere(
          (r) => r?.id == remoteReminder.id,
          orElse: () => null,
        );

        if (localReminder == null || localReminder.syncStatus == 'synced') {
          await _localDb.insertReminder(
            ReminderEntity(
              id: remoteReminder.id,
              title: remoteReminder.title,
              message: remoteReminder.message,
              triggerTime: remoteReminder.triggerTime,
              isSent: remoteReminder.isSent,
              taskId: remoteReminder.taskId,
              activityId: remoteReminder.activityId,
              userId: remoteReminder.userId ?? '',
              syncStatus: 'synced',
              updatedAt: DateTime.now().toUtc(),
              isDeleted: false,
            ),
          );
        }
      }
    } on DioException catch (_) {}
  }

  Future<ReminderModel> addReminder(
    String title,
    DateTime triggerTime, {
    String? message,
    String? taskId,
    String? activityId,
  }) async {
    final uuid = const Uuid().v4();
    final localEntity = ReminderEntity(
      id: uuid,
      title: title,
      message: message,
      triggerTime: triggerTime,
      isSent: false,
      taskId: taskId,
      activityId: activityId,
      userId: 'offline_placeholder',
      syncStatus: 'pending_insert',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
    );
    await _localDb.insertReminder(localEntity);

    try {
      final remoteReminder = await _apiService.createReminder({
        'title': title,
        'trigger_time': triggerTime.toUtc().toIso8601String(),
        'message': message,
        if (taskId != null) 'task_id': taskId,
        if (activityId != null) 'activity_id': activityId,
      });

      await _localDb.updateReminder(localEntity.copyWith(
        id: remoteReminder.id,
        syncStatus: 'synced',
      ));
      return remoteReminder;
    } catch (_) {
      return ReminderModel(
        id: uuid,
        title: title,
        message: message,
        triggerTime: triggerTime,
        isSent: false,
        taskId: taskId,
        activityId: activityId,
        userId: 'offline_placeholder',
      );
    }
  }

  Future<void> deleteReminder(String id) async {
    await _localDb.softDeleteReminder(id);
    try {
      await _apiService.deleteReminder(id);
    } catch (_) {}
  }
}

@riverpod
ReminderRepository reminderRepository(Ref ref) {
  final apiService = ref.watch(reminderApiServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  return ReminderRepository(db.remindersDao, apiService);
}
