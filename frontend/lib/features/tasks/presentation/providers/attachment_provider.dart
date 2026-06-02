import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/local_db/app_database.dart';
import 'package:frontend/features/tasks/data/attachment_repository.dart';

part 'attachment_provider.g.dart';

@riverpod
Stream<List<dynamic>> taskAttachments(Ref ref, String taskId) {
  final repo = ref.watch(attachmentRepositoryProvider);
  // Fetch from remote first
  repo.fetchAttachments(taskId);
  // Watch local stream
  return repo.watchAttachments(taskId);
}
