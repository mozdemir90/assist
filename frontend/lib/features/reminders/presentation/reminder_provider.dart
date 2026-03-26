import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/reminder_model.dart';
import '../data/repository/reminder_repository.dart';

part 'reminder_provider.g.dart';

@riverpod
class ReminderList extends _$ReminderList {
  @override
  Future<List<ReminderModel>> build() async {
    return ref.watch(reminderRepositoryProvider).getReminders();
  }

  Future<void> addReminder(
    String title,
    DateTime time, {
    String? message,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(reminderRepositoryProvider)
          .addReminder(title, time, message: message);
      return ref.read(reminderRepositoryProvider).getReminders();
    });
  }

  Future<void> deleteReminder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(reminderRepositoryProvider).deleteReminder(id);
      return ref.read(reminderRepositoryProvider).getReminders();
    });
  }
}
