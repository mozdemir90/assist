import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../remote/reminder_api_service.dart';
import '../../domain/reminder_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'reminder_repository.g.dart';

class ReminderRepository {
  final ReminderApiService _apiService;

  ReminderRepository(this._apiService);

  Future<List<ReminderModel>> getReminders() {
    return _apiService.getReminders();
  }

  Future<ReminderModel> addReminder(
    String title,
    DateTime triggerTime, {
    String? message,
  }) {
    return _apiService.createReminder({
      'title': title,
      'trigger_time': triggerTime.toUtc().toIso8601String(),
      'message': message,
    });
  }

  Future<void> deleteReminder(String id) {
    return _apiService.deleteReminder(id);
  }
}

@riverpod
ReminderRepository reminderRepository(Ref ref) {
  final apiService = ref.watch(reminderApiServiceProvider);
  return ReminderRepository(apiService);
}
