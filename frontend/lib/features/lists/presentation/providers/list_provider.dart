import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/list_repository.dart';
import '../../../../core/local_db/app_database.dart';

final listsStreamProvider = StreamProvider<List<ListEntity>>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  return repository.watchLists();
});
