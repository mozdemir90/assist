import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/local_db/daos/activities_dao.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/error/exceptions.dart';
import '../domain/activity_model.dart';
import 'activity_api_service.dart';

part 'activity_repository.g.dart';

class ActivityRepository {
  final ActivitiesDao _localDb;
  final ActivityApiService _apiService;

  ActivityRepository(this._localDb, this._apiService);

  Stream<List<ActivityModel>> watchActivities() {
    return _localDb.watchAllActivities().map((entities) {
      return entities
          .map((e) => ActivityModel(
                id: e.id,
                title: e.title,
                description: e.description ?? '',
                startTime: e.startTime?.toIso8601String(),
                endTime: e.endTime?.toIso8601String(),
                duration: e.duration,
                userId: e.userId,
                updatedAt: e.updatedAt?.toIso8601String(),
                isDeleted: e.isDeleted,
              ))
          .toList();
    });
  }

  Future<void> fetchAndSyncActivities() async {
    await _pushPendingChanges();
    try {
      final remoteActivities = await _apiService.getActivities();
      for (final activity in remoteActivities) {
        await _localDb.insertActivity(ActivityEntity(
          id: activity.id,
          title: activity.title,
          description: activity.description,
          startTime: activity.startTime != null ? DateTime.parse(activity.startTime!) : null,
          endTime: activity.endTime != null ? DateTime.parse(activity.endTime!) : null,
          duration: activity.duration,
          userId: activity.userId ?? '',
          syncStatus: 'synced',
          updatedAt: activity.updatedAt != null ? DateTime.parse(activity.updatedAt!) : null,
          isDeleted: activity.isDeleted,
        ));
      }
    } on DioException catch (e) {
      appLogger.w('Activity Network sync failed: \${e.message}');
    } catch (e, st) {
      appLogger.e('Unexpected error during activity sync', error: e, stackTrace: st);
    }
  }

  Future<void> _pushPendingChanges() async {
    final pendingActivities = await _localDb.getPendingActivities();
    for (final actEntity in pendingActivities) {
      final actModel = ActivityModel(
        id: actEntity.id,
        title: actEntity.title,
        description: actEntity.description ?? '',
        startTime: actEntity.startTime?.toIso8601String(),
        endTime: actEntity.endTime?.toIso8601String(),
        duration: actEntity.duration,
        userId: actEntity.userId,
        isDeleted: actEntity.isDeleted,
      );

      try {
        if (actEntity.syncStatus == 'pending_insert') {
          await _apiService.createActivity(actModel);
        } else if (actEntity.syncStatus == 'pending_update') {
          await _apiService.updateActivity(actModel);
        } else if (actEntity.syncStatus == 'pending_delete') {
          await _apiService.deleteActivity(actEntity.id);
        }
        await _localDb.updateActivity(actEntity.copyWith(syncStatus: 'synced'));
      } catch (e) {
        // Skip and retry later
      }
    }
  }

  Future<void> createActivity(ActivityModel activity) async {
    final localActivity = ActivityEntity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      startTime: activity.startTime != null ? DateTime.parse(activity.startTime!) : null,
      endTime: activity.endTime != null ? DateTime.parse(activity.endTime!) : null,
      duration: activity.duration,
      userId: activity.userId ?? 'offline_placeholder',
      syncStatus: 'pending_insert',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
    );
    await _localDb.insertActivity(localActivity);
    fetchAndSyncActivities();
  }

  Future<void> updateActivity(ActivityModel activity) async {
    final localActivity = ActivityEntity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      startTime: activity.startTime != null ? DateTime.parse(activity.startTime!) : null,
      endTime: activity.endTime != null ? DateTime.parse(activity.endTime!) : null,
      duration: activity.duration,
      userId: activity.userId ?? 'offline_placeholder',
      syncStatus: 'pending_update',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: activity.isDeleted,
    );
    await _localDb.updateActivity(localActivity);
    fetchAndSyncActivities();
  }

  Future<void> deleteActivity(String id) async {
    await _localDb.softDeleteActivity(id);
    fetchAndSyncActivities();
  }
}

@riverpod
ActivityRepository activityRepository(ActivityRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(activityApiServiceProvider);
  return ActivityRepository(db.activitiesDao, api);
}
