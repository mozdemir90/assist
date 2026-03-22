import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/tasks/presentation/task_list_screen.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/activities/presentation/screens/activity_list_screen.dart';
import '../../features/lists/presentation/screens/lists_screen.dart';
import 'main_shell_screen.dart';

part 'app_router.g.dart';

class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      return authState.maybeWhen(
        initial: () => '/splash',
        loading: () {
           // If we are navigating between login/register during loading, don't interrupt
           if(state.matchedLocation == '/login' || state.matchedLocation == '/register') return null;
           return '/splash';
        },
        unauthenticated: () {
          final isLogin = state.matchedLocation == '/login';
          final isRegister = state.matchedLocation == '/register';
          final isForgot = state.matchedLocation == '/forgot-password';
          if (isLogin || isRegister || isForgot) return null;
          return '/login';
        },
        authenticated: (_) {
          final isLogin = state.matchedLocation == '/login';
          final isRegister = state.matchedLocation == '/register';
          final isSplash = state.matchedLocation == '/splash';
          if (isLogin || isRegister || isSplash) return '/';
          return null;
        },
        error: (_) {
           if(state.matchedLocation == '/login' || state.matchedLocation == '/register') return null;
           return '/login';
        },
        orElse: () => null,
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashLoader(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'tasks',
                builder: (context, state) => const TaskListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lists',
                name: 'lists',
                builder: (context, state) => const ListsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activities',
                name: 'activities',
                builder: (context, state) => const ActivityListScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  );
}
