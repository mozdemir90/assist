import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/activity_repository.dart';
import '../domain/activity_model.dart';

final activityListProvider = StreamProvider<List<ActivityModel>>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  Future.microtask(() => repo.fetchAndSyncActivities());
  return repo.watchActivities();
});

class ActivityNotifierActions {
  final ActivityRepository repo;

  ActivityNotifierActions(this.repo);

  Future<void> addActivity(String title, {String description = '', int? duration}) async {
    final activity = ActivityModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      duration: duration,
      startTime: DateTime.now().toUtc().toIso8601String(),
    );
    await repo.createActivity(activity);
  }

  Future<void> deleteActivity(String id) async {
    await repo.deleteActivity(id);
  }
}

final activityNotifierActionsProvider = Provider<ActivityNotifierActions>((ref) {
  return ActivityNotifierActions(ref.watch(activityRepositoryProvider));
});
