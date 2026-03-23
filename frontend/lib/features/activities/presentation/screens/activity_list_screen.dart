<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/presentation/providers/auth_notifier.dart';
import '../providers/activity_notifier.dart';
=======
import "package:easy_localization/easy_localization.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/presentation/providers/auth_notifier.dart';
import 'providers/activity_notifier.dart';
>>>>>>> Stashed changes

class ActivityListScreen extends ConsumerWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsyncValue = ref.watch(activityListProvider);
    final actions = ref.watch(activityNotifierActionsProvider);

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: const Text('ODAK Activities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
=======
        title: Text('activities'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr(),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
>>>>>>> Stashed changes
            },
          )
        ],
      ),
      body: activitiesAsyncValue.when(
        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_run, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
<<<<<<< Updated upstream
                    'No activities logged yet.',
=======
                    'no_activities'.tr(),
>>>>>>> Stashed changes
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: activities.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Dismissible(
                key: Key(activity.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  actions.deleteActivity(activity.id);
                  ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< Updated upstream
                    const SnackBar(
                      content: Text('Activity deleted'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
=======
                    SnackBar(
                      content: Text('activity_deleted'.tr()),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
>>>>>>> Stashed changes
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.fitness_center, color: Colors.white),
                    ),
                    title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: activity.description.isNotEmpty ? Text(activity.description) : null,
                    trailing: activity.duration != null
                        ? Text('\${activity.duration} mins', style: const TextStyle(color: Colors.grey))
                        : null,
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
        onPressed: () => _showAddActivityDialog(context, actions),
<<<<<<< Updated upstream
        tooltip: 'Log Activity',
=======
        tooltip: 'log_activity'.tr(),
>>>>>>> Stashed changes
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddActivityDialog(BuildContext context, ActivityNotifierActions actions) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();

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
                'Log Activity',
=======
                'log_activity'.tr(),
>>>>>>> Stashed changes
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
<<<<<<< Updated upstream
                decoration: const InputDecoration(
                  labelText: 'Activity Name (e.g. Running, Reading)',
                  border: OutlineInputBorder(),
=======
                decoration: InputDecoration(
                  labelText: 'activity_name_hint'.tr(),
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
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
=======
                decoration: InputDecoration(
                  labelText: 'description_optional'.tr(),
                  border: const OutlineInputBorder(),
>>>>>>> Stashed changes
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
<<<<<<< Updated upstream
                decoration: const InputDecoration(
                  labelText: 'Duration (in minutes)',
                  border: OutlineInputBorder(),
=======
                decoration: InputDecoration(
                  labelText: 'duration_mins'.tr(),
                  border: const OutlineInputBorder(),
>>>>>>> Stashed changes
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    int? duration;
                    if (durationController.text.isNotEmpty) {
                      duration = int.tryParse(durationController.text.trim());
                    }
                    actions.addActivity(
                      title,
                      description: descriptionController.text.trim(),
                      duration: duration,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
<<<<<<< Updated upstream
                child: const Text('Log Activity', style: TextStyle(fontSize: 16)),
=======
                child: Text('log_activity'.tr(), style: const TextStyle(fontSize: 16)),
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
