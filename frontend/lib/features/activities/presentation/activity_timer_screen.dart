import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'activity_provider.dart';

class ActivityTimerScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final String? taskTitle;

  const ActivityTimerScreen({super.key, this.taskId, this.taskTitle});

  @override
  ConsumerState<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends ConsumerState<ActivityTimerScreen> {
  final _notesController = TextEditingController();

  String _formatDuration(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return seconds >= 3600 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(activityTimerProvider);
    final isRunning = timerState.isRunning;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.taskTitle ?? 'General Activity'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth < 200 ? 200.0 : (constraints.maxWidth * 0.8 > 400 ? 400.0 : constraints.maxWidth * 0.8);
                      return SizedBox(
                        width: size,
                        height: size,
                        child: CircularProgressIndicator(
                          value: isRunning ? null : (timerState.elapsedSeconds % 60) / 60,
                          strokeWidth: 8,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isRunning ? AppColors.primaryBlue : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDuration(timerState.elapsedSeconds),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textPrimaryLight,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        isRunning ? 'FOCUSING' : 'PAUSED',
                        style: TextStyle(
                          letterSpacing: 2,
                          color: isRunning ? AppColors.primaryBlue : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'timer_notes_hint'.tr(),
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _notesController,
                builder: (context, value, _) {
                  final hasNotes = value.text.isNotEmpty;
                  final showSave = timerState.elapsedSeconds > 0 || hasNotes;
                  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isRunning && timerState.elapsedSeconds == 0)
                        _TimerButton(
                          icon: Icons.play_arrow_rounded,
                          color: AppColors.primaryBlue,
                          onPressed: () =>
                              ref.read(activityTimerProvider.notifier).start(widget.taskId),
                        )
                      else if (isRunning)
                        _TimerButton(
                          icon: Icons.pause_rounded,
                          color: Colors.orange,
                          onPressed: () =>
                              ref.read(activityTimerProvider.notifier).pause(),
                        )
                      else
                        _TimerButton(
                          icon: Icons.play_arrow_rounded,
                          color: AppColors.primaryBlue,
                          onPressed: () =>
                              ref.read(activityTimerProvider.notifier).start(widget.taskId),
                        ),
                      if (showSave) ...[
                        const SizedBox(width: 40),
                        _TimerButton(
                          icon: Icons.check_rounded,
                          color: AppColors.primaryGreen,
                          onPressed: () async {
                            await ref
                                .read(activityTimerProvider.notifier)
                                .stopAndSave(
                                  widget.taskTitle ?? 'General Activity',
                                  description: _notesController.text.isNotEmpty
                                      ? _notesController.text
                                      : 'Tracked via timer',
                                  taskId: widget.taskId,
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('activity_saved'.tr()),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              context.pop();
                            }
                          },
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _TimerButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(icon, size: 48, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
