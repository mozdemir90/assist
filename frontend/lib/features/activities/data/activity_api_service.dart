import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../domain/activity_model.dart';

part 'activity_api_service.g.dart';

class ActivityApiService {
  final ApiClient _apiClient;

  ActivityApiService(this._apiClient);

  Future<List<ActivityModel>> getActivities() async {
    final response = await _apiClient.dio.get('/activities/');
    return (response.data as List).map((json) => ActivityModel.fromJson(json)).toList();
  }

  Future<ActivityModel> createActivity(ActivityModel activity) async {
    final response = await _apiClient.dio.post('/activities/', data: activity.toJson());
    return ActivityModel.fromJson(response.data);
  }

  Future<ActivityModel> updateActivity(ActivityModel activity) async {
    final response = await _apiClient.dio.put('/activities/\${activity.id}', data: activity.toJson());
    return ActivityModel.fromJson(response.data);
  }

  Future<void> deleteActivity(String id) async {
    await _apiClient.dio.delete('/activities/\$id');
  }
}

@riverpod
ActivityApiService activityApiService(Ref ref) {
  return ActivityApiService(ref.watch(apiClientProvider));
}
