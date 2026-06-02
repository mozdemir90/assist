import 'package:drift/drift.dart';
import '../app_database.dart';

part 'task_attachments_dao.g.dart';

@DriftAccessor(tables: [TaskAttachments])
class TaskAttachmentsDao extends DatabaseAccessor<AppDatabase> with _$TaskAttachmentsDaoMixin {
  final AppDatabase db;

  TaskAttachmentsDao(this.db) : super(db);

  Stream<List<TaskAttachmentEntity>> watchAttachmentsByTask(String taskId) =>
      (select(taskAttachments)..where((a) => a.taskId.equals(taskId))).watch();

  Future<List<TaskAttachmentEntity>> getAttachmentsByTask(String taskId) =>
      (select(taskAttachments)..where((a) => a.taskId.equals(taskId))).get();

  Future<int> insertAttachment(TaskAttachmentEntity attachment) =>
      into(taskAttachments).insert(attachment, mode: InsertMode.insertOrReplace);

  Future<int> deleteAttachment(String id) =>
      (delete(taskAttachments)..where((a) => a.id.equals(id))).go();
}
