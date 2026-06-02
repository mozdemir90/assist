import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../data/attachment_repository.dart';

part 'attachment_provider.g.dart';

@riverpod
Stream<dynamic> taskAttachments(TaskAttachmentsRef ref, String taskId) {
  final repo = ref.watch(attachmentRepositoryProvider);
  // Fetch from remote first
  repo.fetchAttachments(taskId);
  // Watch local stream
  return repo.watchAttachments(taskId);
}
