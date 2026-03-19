import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Dashboard')),
        ),
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
