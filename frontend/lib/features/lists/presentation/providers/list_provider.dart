import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/list_repository.dart';
import '../../../../core/local_db/app_database.dart';

final listsStreamProvider = StreamProvider<List<ListEntity>>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  return repository.watchLists();
});

final listByIdProvider = Provider.family<ListEntity?, String>((ref, id) {
  final listsAsync = ref.watch(listsStreamProvider);
  return listsAsync.when(
    data: (lists) {
      try {
        return lists.firstWhere((l) => l.id == id);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
