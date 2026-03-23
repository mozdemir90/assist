import "package:easy_localization/easy_localization.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< Updated upstream
import 'package:go_router/go_router.dart';
=======
>>>>>>> Stashed changes
import 'package:frontend/features/auth/presentation/providers/auth_notifier.dart';
import 'providers/task_notifier.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(taskListProvider);
    final actions = ref.watch(taskNotifierActionsProvider);

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: const Text('ODAK Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
=======
        title: Text('tasks'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr(),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          )
>>>>>>> Stashed changes
        ],
      ),
      body: tasksAsyncValue.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
<<<<<<< Updated upstream
                    'No tasks yet. Stay focused!',
=======
                    'no_tasks'.tr(),
>>>>>>> Stashed changes
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  actions.deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< Updated upstream
                    const SnackBar(
                      content: Text('Task deleted'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
=======
                    SnackBar(
                      content: Text('task_deleted'.tr()),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
>>>>>>> Stashed changes
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: CheckboxListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
<<<<<<< Updated upstream
                    subtitle: task.description.isNotEmpty
                        ? Text(task.description)
                        : null,
                    secondary: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_circle_outline, color: Colors.blue),
                          onPressed: () {
                            context.push('/timer', extra: {
                              'taskId': task.id,
                              'taskTitle': task.title,
                            });
                          },
                        ),
                      ],
                    ),
=======
                    subtitle: task.description.isNotEmpty
                        ? Text(task.description)
                        : null,
>>>>>>> Stashed changes
                    value: task.isCompleted,
                    onChanged: (_) {
                      actions.toggleTaskCompletion(task);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref, actions),
        child: const Icon(Icons.add),
<<<<<<< Updated upstream
        tooltip: 'Add Task',
=======
        tooltip: 'add_task'.tr(),
>>>>>>> Stashed changes
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref, TaskNotifierActions actions) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
<<<<<<< Updated upstream
                'New Task',
=======
                'new_task'.tr(),
>>>>>>> Stashed changes
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
<<<<<<< Updated upstream
                decoration: const InputDecoration(
                  labelText: 'What needs to be done?',
                  border: OutlineInputBorder(),
=======
                decoration: InputDecoration(
                  labelText: 'task_title_hint'.tr(),
                  border: const OutlineInputBorder(),
>>>>>>> Stashed changes
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
<<<<<<< Updated upstream
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
=======
                decoration: InputDecoration(
                  labelText: 'description_optional'.tr(),
                  border: const OutlineInputBorder(),
>>>>>>> Stashed changes
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    actions.addTask(
                      title,
                      description: descriptionController.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
<<<<<<< Updated upstream
                child: const Text('Add Task', style: TextStyle(fontSize: 16)),
=======
                child: Text('add_task'.tr(), style: const TextStyle(fontSize: 16)),
>>>>>>> Stashed changes
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
