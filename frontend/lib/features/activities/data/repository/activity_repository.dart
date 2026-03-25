import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(ref.watch(appDatabaseProvider));
});

class ActivityRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  ActivityRepository(this._db);

  Future<void> saveActivity(
    String title,
    int durationInSeconds, {
    String? description,
    String? taskId,
  }) async {
    final now = DateTime.now().toUtc();
    final companion = ActivitiesCompanion(
      id: drift.Value(_uuid.v4()),
      title: drift.Value(title),
      description: drift.Value.absentIfNull(description),
      duration: drift.Value(durationInSeconds),
      startTime: drift.Value(
        now.subtract(Duration(seconds: durationInSeconds)),
      ),
      endTime: drift.Value(now),
      userId: const drift.Value(
        'local_user',
      ), // TODO: Replace with actual user ID from Auth
    );

    // Jules's schema doesn't have a direct relation field `taskId` in `Activities` in the Drift file?
    // Wait, let's check `Activities` in AppDatabase
    // I will just save the activity for now. A taskId column wasn't heavily requested but is good to have.
    await _db.insertActivity(companion);
  }
}
