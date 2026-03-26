import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reminder_provider.dart';
import '../../../core/theme/app_colors.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(reminderListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hatırlatıcılar (Reminders)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddReminderDialog(context, ref);
            },
          ),
        ],
      ),
      body: remindersAsync.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_add,
                    size: 64,
                    color: AppColors.textSecondaryLight.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz hatırlatıcı yok.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final isPast = reminder.triggerTime.isBefore(DateTime.now());
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppColors.textSecondaryLight.withOpacity(0.1),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: isPast
                        ? AppColors.textSecondaryLight
                        : AppColors.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      Icons.alarm,
                      color: isPast ? Colors.white : AppColors.primaryBlue,
                    ),
                  ),
                  title: Text(
                    reminder.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "\${reminder.triggerTime.hour.toString().padLeft(2, '0')}:\${reminder.triggerTime.minute.toString().padLeft(2, '0')} - \${reminder.triggerTime.day}/\${reminder.triggerTime.month}",
                    style: TextStyle(
                      color: isPast
                          ? AppColors.errorRed
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.errorRed,
                    ),
                    onPressed: () {
                      ref
                          .read(reminderListProvider.notifier)
                          .deleteReminder(reminder.id);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Yeni Hatırlatıcı",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Ne hatırlatalım?',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final now = DateTime.now();
                    final trigger = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    ref
                        .read(reminderListProvider.notifier)
                        .addReminder(
                          titleController.text,
                          trigger.isBefore(now)
                              ? trigger.add(const Duration(days: 1))
                              : trigger,
                        );
                    Navigator.pop(ctx);
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
