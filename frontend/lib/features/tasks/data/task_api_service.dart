import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../domain/task_model.dart';

part 'task_api_service.g.dart';

class TaskApiService {
  final ApiClient _apiClient;

  TaskApiService(this._apiClient);

  Future<List<TaskModel>> getTasks() async {
    final response = await _apiClient.dio.get('/tasks/');
    return (response.data as List)
        .map((json) => TaskModel.fromJson(json))
        .toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await _apiClient.dio.post('/tasks/', data: task.toJson());
    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _apiClient.dio.put(
      '/tasks/\${task.id}',
      data: task.toJson(),
    );
    return TaskModel.fromJson(response.data);
  }

  Future<void> deleteTask(String id) async {
    await _apiClient.dio.delete('/tasks/\$id');
  }
}

@riverpod
TaskApiService taskApiService(Ref ref) {
  return TaskApiService(ref.watch(apiClientProvider));
}
