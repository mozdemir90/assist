import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(ref.watch(apiClientProvider).dio);
});

class TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSource(this._dio);

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    try {
      final response = await _dio.get('/tasks/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to fetch tasks from server: $e');
    }
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    try {
      final response = await _dio.post('/tasks/', data: taskData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to create task on server: $e');
    }
  }

  Future<Map<String, dynamic>> updateTask(
    String id,
    Map<String, dynamic> taskData,
  ) async {
    try {
      final response = await _dio.put('/tasks/$id', data: taskData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update task on server: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/tasks/$id');
    } catch (e) {
      throw Exception('Failed to delete task on server: $e');
    }
  }
}
