import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/reminder_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_api_service.g.dart';

class ReminderApiService {
  final Dio _dio;

  ReminderApiService(this._dio);

  Future<List<ReminderModel>> getReminders() async {
    final response = await _dio.get('/reminders/');
    final List<dynamic> data = response.data;
    return data.map((json) => ReminderModel.fromJson(json)).toList();
  }

  Future<ReminderModel> createReminder(Map<String, dynamic> data) async {
    final response = await _dio.post('/reminders/', data: data);
    return ReminderModel.fromJson(response.data);
  }

  Future<ReminderModel> updateReminder(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put('/reminders/$id', data: data);
    return ReminderModel.fromJson(response.data);
  }

  Future<void> deleteReminder(String id) async {
    await _dio.delete('/reminders/$id');
  }
}

@riverpod
ReminderApiService reminderApiService(Ref ref) {
  final dio = ref.watch(apiClientProvider).dio;
  return ReminderApiService(dio);
}
