import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/local_db/app_database.dart';

// Manual StreamProvider to avoid generator issues with ActivityEntity
final taskActivitiesProvider = StreamProvider.family<List<ActivityEntity>, String>((ref, taskId) {
  final db = ref.watch(appDatabaseProvider);
  return db.activitiesDao.watchActivitiesByTaskId(taskId);
});
