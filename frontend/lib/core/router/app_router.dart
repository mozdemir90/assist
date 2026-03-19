import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/tasks/presentation/task_list_screen.dart';
import '../../features/activities/presentation/activity_timer_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/timer',
        name: 'timer',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return ActivityTimerScreen(
            taskId: extra?['taskId'],
            taskTitle: extra?['taskTitle'],
          );
        },
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login Page')),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Register Page')),
        ),
      ),
    ],
  );
}
