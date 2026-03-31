import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/auth/presentation/providers/auth_notifier.dart';
import 'providers/task_notifier.dart';
import '../domain/task_model.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../lists/presentation/providers/list_provider.dart';
import '../../../core/theme/app_colors.dart';

class TaskListScreen extends ConsumerWidget {
  final String? listId;
  final String? listName;

  const TaskListScreen({super.key, this.listId, this.listName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.locale; // Ensure rebuild on language change
    final tasksAsyncValue = ref.watch(taskListProvider(listId));
    final actions = ref.watch(taskNotifierActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(listName ?? 'my_tasks'.tr()),
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
                    'no_tasks'.tr(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            );
          }
          final mainTasks = tasks.where((t) => t.listId == null).toList();
          final listTasks = tasks.where((t) => t.listId != null).toList();

          if (listId != null) {
            return _buildTaskList(tasks, actions, ref);
          }

          return CustomScrollView(
            slivers: [
              if (mainTasks.isNotEmpty) ...[
                _buildSectionHeader('main_tasks'.tr()),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTaskItem(context, mainTasks[index], actions, ref),
                    childCount: mainTasks.length,
                  ),
                ),
              ],
              if (listTasks.isNotEmpty) ...[
                _buildSectionHeader('list_tasks'.tr()),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTaskItem(context, listTasks[index], actions, ref),
                    childCount: listTasks.length,
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref, actions, listId),
        tooltip: 'add_task'.tr(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks, TaskNotifierActions actions, WidgetRef ref) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => _buildTaskItem(context, tasks[index], actions, ref),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task, TaskNotifierActions actions, WidgetRef ref) {
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
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.textSecondaryLight.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => context.push('/task-detail/${task.id}'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: IconButton(
                icon: const Icon(Icons.play_circle_outline, color: Colors.blue),
                onPressed: () {
                  context.push('/timer', extra: {'taskId': task.id, 'taskTitle': task.title});
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Consumer(
                        builder: (context, ref, _) {
                          Color? textColor;
                          if (task.listId != null) {
                            final list = ref.watch(listByIdProvider(task.listId!));
                            if (list != null && list.color != null) {
                              textColor = Color(int.parse(list.color!.replaceFirst('#', '0xFF')));
                            }
                          }
                          return Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: task.isCompleted ? Colors.grey : (textColor ?? AppColors.textSecondaryLight),
                              fontWeight: textColor != null ? FontWeight.w500 : null,
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (task.deadline != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(task.deadline!).toLocal()),
                              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      if (listId == null && task.listId != null)
                        Consumer(
                          builder: (context, ref, _) {
                            final list = ref.watch(listByIdProvider(task.listId!));
                            if (list == null) return const SizedBox.shrink();
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.folder_outlined, size: 14, color: AppColors.primaryBlue),
                                const SizedBox(width: 4),
                                Text(
                                  'in_list'.tr(args: [list.name]),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
              trailing: Checkbox(
                activeColor: AppColors.primaryBlue,
                value: task.isCompleted,
                onChanged: (_) => actions.toggleTaskCompletion(task),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _showAddTaskDialog(
    BuildContext context,
    WidgetRef ref,
    TaskNotifierActions actions,
    String? currentListId,
  ) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDeadline;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'new_task'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 16),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'task_title_hint'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      autofocus: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_title'.tr();
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'task_desc_hint'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      selectedDeadline == null
                          ? 'set_deadline'.tr()
                          : DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(selectedDeadline!),
                    ),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            selectedDeadline = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    trailing: selectedDeadline != null
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedDeadline = null;
                              });
                            },
                          )
                        : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final title = titleController.text.trim();
                        actions.addTask(
                          title,
                          description: descriptionController.text.trim(),
                          listId: currentListId,
                          deadline: selectedDeadline?.toUtc().toIso8601String(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'add_task'.tr(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }
}
