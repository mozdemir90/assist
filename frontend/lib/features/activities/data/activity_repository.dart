import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/local_db/daos/activities_dao.dart';
<<<<<<< Updated upstream
=======
import '../../../core/logger/app_logger.dart';
import '../../../core/error/exceptions.dart';
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
    await _pushPendingChanges();
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
          syncStatus: 'synced',
>>>>>>> Stashed changes
          updatedAt: activity.updatedAt != null ? DateTime.parse(activity.updatedAt!) : null,
          isDeleted: activity.isDeleted,
        ));
      }
    } on DioException catch (e) {
<<<<<<< Updated upstream
      print('Activity Network sync failed: \${e.message}');
=======
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
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
      syncStatus: 'pending_insert',
>>>>>>> Stashed changes
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
    );
    await _localDb.insertActivity(localActivity);
<<<<<<< Updated upstream

    try {
      final createdRemote = await _apiService.createActivity(activity);
       await _localDb.insertActivity(ActivityEntity(
          id: createdRemote.id,
          title: createdRemote.title,
          description: createdRemote.description,
          startTime: createdRemote.startTime != null ? DateTime.parse(createdRemote.startTime!) : null,
          endTime: createdRemote.endTime != null ? DateTime.parse(createdRemote.endTime!) : null,
          duration: createdRemote.duration,
          userId: createdRemote.userId ?? '',
          updatedAt: createdRemote.updatedAt != null ? DateTime.parse(createdRemote.updatedAt!) : null,
          isDeleted: createdRemote.isDeleted,
        ));
    } on DioException catch (_) {}
=======
    fetchAndSyncActivities();
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
      syncStatus: 'pending_update',
>>>>>>> Stashed changes
      updatedAt: DateTime.now().toUtc(),
      isDeleted: activity.isDeleted,
    );
    await _localDb.updateActivity(localActivity);
<<<<<<< Updated upstream

    try {
      await _apiService.updateActivity(activity);
    } on DioException catch (_) {}
=======
    fetchAndSyncActivities();
>>>>>>> Stashed changes
  }

  Future<void> deleteActivity(String id) async {
    await _localDb.softDeleteActivity(id);
<<<<<<< Updated upstream
    try {
      await _apiService.deleteActivity(id);
    } on DioException catch (_) {}
=======
    fetchAndSyncActivities();
>>>>>>> Stashed changes
  }
}

@riverpod
<<<<<<< Updated upstream
ActivityRepository activityRepository(Ref ref) {
=======
ActivityRepository activityRepository(ActivityRepositoryRef ref) {
>>>>>>> Stashed changes
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(activityApiServiceProvider);
  return ActivityRepository(db.activitiesDao, api);
}
