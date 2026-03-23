<<<<<<< Updated upstream
=======
import "package:easy_localization/easy_localization.dart";
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/list_provider.dart';
import '../../data/repository/list_repository.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(listsStreamProvider);

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: const Text('ODAK Lists'),
=======
        title: Text('lists'.tr()),
>>>>>>> Stashed changes
      ),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
<<<<<<< Updated upstream
            return const Center(child: Text('No lists yet. Create one!'));
=======
            return Center(child: Text('no_lists'.tr()));
>>>>>>> Stashed changes
          }
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _colorFromHex(list.color ?? '#CCCCCC'),
                ),
                title: Text(list.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(listRepositoryProvider).deleteList(list.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddListDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  void _showAddListDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
<<<<<<< Updated upstream

=======

>>>>>>> Stashed changes
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
<<<<<<< Updated upstream
          title: const Text('New List'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'List Name'),
=======
          title: Text('new_list'.tr()),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'list_name'.tr()),
>>>>>>> Stashed changes
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
<<<<<<< Updated upstream
              child: const Text('Cancel'),
=======
              child: Text('cancel'.tr()),
>>>>>>> Stashed changes
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  ref.read(listRepositoryProvider).createList(name, '#3498db');
                }
                Navigator.pop(context);
              },
<<<<<<< Updated upstream
              child: const Text('Add'),
=======
              child: Text('add'.tr()),
>>>>>>> Stashed changes
            ),
          ],
        );
      },
    );
  }
}
