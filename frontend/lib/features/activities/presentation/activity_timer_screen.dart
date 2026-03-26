import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'activity_provider.dart';

class ActivityTimerScreen extends ConsumerWidget {
  final String? taskId;
  final String? taskTitle;

  const ActivityTimerScreen({super.key, this.taskId, this.taskTitle});

  String _formatDuration(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return seconds >= 3600 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(activityTimerProvider);
    final isRunning = timerState.isRunning;

    return Scaffold(
      appBar: AppBar(
        title: Text(taskTitle ?? 'General Activity'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (timerState.elapsedSeconds > 0 && isRunning) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Timer running in background')),
              );
            }
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(timerState.elapsedSeconds),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 80,
                fontWeight: FontWeight.w200,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isRunning && timerState.elapsedSeconds == 0)
                  FloatingActionButton.large(
                    heroTag: 'start_timer',
                    onPressed: () =>
                        ref.read(activityTimerProvider.notifier).start(taskId),
                    child: const Icon(Icons.play_arrow, size: 40),
                  )
                else if (isRunning)
                  FloatingActionButton.large(
                    heroTag: 'pause_timer',
                    onPressed: () =>
                        ref.read(activityTimerProvider.notifier).pause(),
                    child: const Icon(Icons.pause, size: 40),
                  )
                else
                  FloatingActionButton.large(
                    heroTag: 'resume_timer',
                    onPressed: () =>
                        ref.read(activityTimerProvider.notifier).start(taskId),
                    child: const Icon(Icons.play_arrow, size: 40),
                  ),
                if (timerState.elapsedSeconds > 0) ...[
                  const SizedBox(width: 30),
                  FloatingActionButton.large(
                    heroTag: 'stop_timer',
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    onPressed: () async {
                      await ref
                          .read(activityTimerProvider.notifier)
                          .stopAndSave(
                            taskTitle ?? 'General Activity',
                            description: 'Tracked via timer',
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Activity saved successfully!'),
                          ),
                        );
                        context.pop();
                      }
                    },
                    child: Icon(
                      Icons.stop,
                      size: 40,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
