import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/list_provider.dart';
import '../../data/repository/list_repository.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(listsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text('my_lists'.tr())),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
            return Center(child: Text('no_lists'.tr()));
          }
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return ListTile(
                onTap: () {
                  context.pushNamed(
                    'tasks',
                    queryParameters: {'listId': list.id, 'listName': list.name},
                  );
                },
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('new_list'.tr()),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'list_name_hint'.tr()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  ref.read(listRepositoryProvider).createList(name, '#3498db');
                }
                Navigator.pop(context);
              },
              child: Text('add'.tr()),
            ),
          ],
        );
      },
    );
  }
}
