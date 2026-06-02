import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/local_db/app_database.dart';
import 'package:frontend/core/local_db/daos/task_attachments_dao.dart';

part 'attachment_repository.g.dart';

class AttachmentRepository {
  final TaskAttachmentsDao _localDb;
  final ApiClient _apiClient;

  AttachmentRepository(this._localDb, this._apiClient);

  Stream<List<TaskAttachmentEntity>> watchAttachments(String taskId) {
    return _localDb.watchAttachmentsByTask(taskId);
  }

  Future<void> fetchAttachments(String taskId) async {
    try {
      final response = await _apiClient.dio.get('/tasks/$taskId/attachments');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        for (var item in data) {
          await _localDb.insertAttachment(
            TaskAttachmentEntity(
              id: item['id'],
              taskId: item['task_id'],
              fileName: item['file_name'],
              filePath: item['file_path'],
              createdAt: DateTime.parse(item['created_at']).toUtc(),
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to fetch attachments: $e');
    }
  }

  Future<void> uploadAttachment(String taskId, File file) async {
    final uuid = const Uuid().v4();
    final fileName = file.path.split('/').last;

    // We first insert it locally to show immediately (offline-first approach)
    final localAttachment = TaskAttachmentEntity(
      id: uuid,
      taskId: taskId,
      fileName: fileName,
      filePath: file.path,
      createdAt: DateTime.now().toUtc(),
    );
    await _localDb.insertAttachment(localAttachment);

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        '/tasks/$taskId/attachments',
        data: formData,
      );

      if (response.statusCode == 201) {
        // Update local with remote id and real path
        final data = response.data;
        await _localDb.deleteAttachment(uuid); // Remove temporary local
        await _localDb.insertAttachment(
          TaskAttachmentEntity(
            id: data['id'],
            taskId: data['task_id'],
            fileName: data['file_name'],
            filePath: data['file_path'],
            createdAt: DateTime.parse(data['created_at']).toUtc(),
          ),
        );
      }
    } catch (e) {
      print('Failed to upload attachment: $e');
      // If upload fails, keep local. A robust sync would retry later.
    }
  }

  Future<void> deleteAttachment(String attachmentId) async {
    await _localDb.deleteAttachment(attachmentId);
    try {
      await _apiClient.dio.delete('/tasks/attachments/$attachmentId');
    } catch (e) {
      print('Failed to delete attachment remotely: $e');
    }
  }
}

@riverpod
AttachmentRepository attachmentRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final db = ref.watch(appDatabaseProvider);
  return AttachmentRepository(db.taskAttachmentsDao, api);
}
