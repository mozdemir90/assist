import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/tasks/domain/task_model.dart';
import 'package:frontend/features/tasks/presentation/providers/task_notifier.dart';
import 'package:frontend/features/activities/presentation/activity_provider.dart';
import 'package:frontend/features/activities/presentation/task_activities_provider.dart';
import 'package:frontend/features/activities/presentation/activity_timer_screen.dart';
import 'package:frontend/features/reminders/data/repository/reminder_repository.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskByIdProvider(widget.taskId));
    final actions = ref.watch(taskNotifierActionsProvider);

    return taskAsync.when(
      data: (task) {
        if (!_isEditing) {
          _descriptionController.text = task.description;
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('task_details'.tr()),
            actions: [
              IconButton(
                icon: Icon(task.isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                onPressed: () => actions.toggleTaskCompletion(task),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader('description_notes'.tr()),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'add_notes_hint'.tr(),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() => _isEditing = true);
                      },
                    ),
                  ),
                ),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedTask = task.copyWith(description: _descriptionController.text);
                        await actions.repo.updateTask(updatedTask);
                        setState(() => _isEditing = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('notes_saved'.tr())),
                          );
                        }
                      },
                      child: Text('save_notes'.tr()),
                    ),
                  ),
                const SizedBox(height: 32),
                _buildSectionHeader('reminders'.tr()),
                const SizedBox(height: 12),
                ListTile(
                  tileColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: const Icon(Icons.notifications_active_outlined, color: Colors.blue),
                  title: Text('remind_me'.tr()),
                  subtitle: Text('remind_me_desc'.tr()),
                  onTap: () async {
                    // Logic for reminder
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null && context.mounted) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        final triggerTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        try {
                          await ref.read(reminderListProvider.notifier).addReminder(
                                'Reminder: ${task.title}',
                                triggerTime,
                                message: 'Your task "${task.title}" reminder.',
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('reminder_set'.tr(args: [DateFormat.yMMMd().add_jm().format(triggerTime)])),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error setting reminder: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildActiveReminders(task.id),
                const SizedBox(height: 32),
                _buildSectionHeader('attachments'.tr()),
                const SizedBox(height: 12),
                _buildFilePickerArea(),
                const SizedBox(height: 32),
                _buildSectionHeader('session_history'.tr()),
                const SizedBox(height: 12),
                _buildSessionHistory(),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push('/timer', extra: {'taskId': task.id, 'taskTitle': task.title});
            },
            label: Text('start_timer'.tr()),
            icon: const Icon(Icons.play_arrow),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildFilePickerArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles();
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('File selected: ${result.files.first.name}')),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.blue),
                const SizedBox(height: 12),
                Text('add_files_hint'.tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionHistory() {
    final historyAsync = ref.watch(taskActivitiesProvider(widget.taskId));

    return historyAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return Card(
            elevation: 0,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blue.withOpacity(0.05)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'no_sessions'.tr(),
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final startTime = activity.startTime != null 
                ? DateFormat('dd MMM, HH:mm').format(activity.startTime!)
                : '---';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.withOpacity(0.1)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      startTime,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'duration'.tr(args: [_formatDuration(activity.duration ?? 0)]),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: activity.description != null && activity.description!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          activity.description!,
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error loading history: $e'),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds == 0) return '0s';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    final parts = <String>[];
    if (h > 0) parts.add('${h}h');
    if (m > 0) parts.add('${m}m');
    if (s > 0 || parts.isEmpty) parts.add('${s}s');
    return parts.join(' ');
  }

  Widget _buildActiveReminders(String taskId) {
    final remindersAsync = ref.watch(reminderListProvider);

    return remindersAsync.when(
      data: (reminders) {
        final taskReminders = reminders.where((r) => r.taskId == taskId).toList();
        if (taskReminders.isEmpty) return const SizedBox.shrink();

        return Column(
          children: taskReminders.map((reminder) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.alarm, size: 20, color: Colors.blue),
                title: Text(
                  DateFormat('dd MMM, HH:mm').format(DateTime.parse(reminder.triggerTime).toLocal()),
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                  onPressed: () => ref.read(reminderListProvider.notifier).deleteReminder(reminder.id),
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(strokeWidth: 2))),
      error: (e, st) => Text('Error loading reminders: $e', style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }
}
