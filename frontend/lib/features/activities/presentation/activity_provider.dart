import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/activity_repository.dart';

part 'activity_provider.g.dart';

class TimerState {
  final bool isRunning;
  final int elapsedSeconds;
  final String? currentTaskId;

  const TimerState({
    this.isRunning = false,
    this.elapsedSeconds = 0,
    this.currentTaskId,
  });

  TimerState copyWith({
    bool? isRunning,
    int? elapsedSeconds,
    String? currentTaskId,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      currentTaskId: currentTaskId ?? this.currentTaskId,
    );
  }
}

@riverpod
class ActivityTimer extends _$ActivityTimer {
  Timer? _timer;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const TimerState();
  }

  void start(String? taskId) {
    if (state.isRunning) return;
    state = state.copyWith(
      isRunning: true,
      currentTaskId: taskId ?? state.currentTaskId,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  Future<void> stopAndSave(String title, {String? description, String? taskId}) async {
    final effectiveTaskId = taskId ?? state.currentTaskId;
    final hasDescription = description != null && description.trim().isNotEmpty;

    if (state.elapsedSeconds == 0 && !hasDescription) return;
    pause();

    final repo = ref.read(activityRepositoryProvider);
    await repo.saveActivity(
      title,
      state.elapsedSeconds,
      description: description,
      taskId: effectiveTaskId,
    );

    state = const TimerState(); // Reset
  }
}
