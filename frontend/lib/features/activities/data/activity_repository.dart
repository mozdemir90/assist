import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/local_db/daos/activities_dao.dart';
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
          .map(
            (e) => ActivityModel(
              id: e.id,
              title: e.title,
              description: e.description ?? '',
              startTime: e.startTime?.toIso8601String(),
              endTime: e.endTime?.toIso8601String(),
              duration: e.duration,
              userId: e.userId,
              updatedAt: e.updatedAt?.toIso8601String(),
              isDeleted: e.isDeleted,
            ),
          )
          .toList();
    });
  }

  Future<void> fetchAndSyncActivities() async {
    try {
      final remoteActivities = await _apiService.getActivities();
      for (final activity in remoteActivities) {
        await _localDb.insertActivity(
          ActivityEntity(
            id: activity.id,
            title: activity.title,
            description: activity.description,
            startTime: activity.startTime != null
                ? DateTime.parse(activity.startTime!)
                : null,
            endTime: activity.endTime != null
                ? DateTime.parse(activity.endTime!)
                : null,
            duration: activity.duration,
            userId: activity.userId ?? '',
            updatedAt: activity.updatedAt != null
                ? DateTime.parse(activity.updatedAt!)
                : null,
            isDeleted: activity.isDeleted,
          ),
        );
      }
    } on DioException catch (e) {
      print('Activity Network sync failed: \${e.message}');
    }
  }

  Future<void> createActivity(ActivityModel activity) async {
    final localActivity = ActivityEntity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      startTime: activity.startTime != null
          ? DateTime.parse(activity.startTime!)
          : null,
      endTime: activity.endTime != null
          ? DateTime.parse(activity.endTime!)
          : null,
      duration: activity.duration,
      userId: activity.userId ?? 'offline_placeholder',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
    );
    await _localDb.insertActivity(localActivity);

    try {
      final createdRemote = await _apiService.createActivity(activity);
      await _localDb.insertActivity(
        ActivityEntity(
          id: createdRemote.id,
          title: createdRemote.title,
          description: createdRemote.description,
          startTime: createdRemote.startTime != null
              ? DateTime.parse(createdRemote.startTime!)
              : null,
          endTime: createdRemote.endTime != null
              ? DateTime.parse(createdRemote.endTime!)
              : null,
          duration: createdRemote.duration,
          userId: createdRemote.userId ?? '',
          updatedAt: createdRemote.updatedAt != null
              ? DateTime.parse(createdRemote.updatedAt!)
              : null,
          isDeleted: createdRemote.isDeleted,
        ),
      );
    } on DioException catch (_) {}
  }

  Future<void> updateActivity(ActivityModel activity) async {
    final localActivity = ActivityEntity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      startTime: activity.startTime != null
          ? DateTime.parse(activity.startTime!)
          : null,
      endTime: activity.endTime != null
          ? DateTime.parse(activity.endTime!)
          : null,
      duration: activity.duration,
      userId: activity.userId ?? 'offline_placeholder',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: activity.isDeleted,
    );
    await _localDb.updateActivity(localActivity);

    try {
      await _apiService.updateActivity(activity);
    } on DioException catch (_) {}
  }

  Future<void> deleteActivity(String id) async {
    await _localDb.softDeleteActivity(id);
    try {
      await _apiService.deleteActivity(id);
    } on DioException catch (_) {}
  }
}

@riverpod
ActivityRepository activityRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(activityApiServiceProvider);
  return ActivityRepository(db.activitiesDao, api);
}
