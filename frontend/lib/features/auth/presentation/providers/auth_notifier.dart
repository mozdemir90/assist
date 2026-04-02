import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import 'auth_state.dart';
import '../../../sync/presentation/providers/sync_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkInitialAuth();
    return AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    state = AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final isAuth = await repo.isAuthenticated();
      if (isAuth) {
        final user = await repo.getProfile();
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          // If token exists but profile fetch fails, consider as unauthenticated
          state = AuthState.unauthenticated();
        }
        // Trigger background sync
        ref.read(syncProvider).syncAll();

        // Push Notification Setup
        _setupPushNotifications(repo);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> _setupPushNotifications(AuthRepository repo) async {
    try {
      if (!kIsWeb) {
        print('DEBUG [FCM]: Requesting push notification permissions...');
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        print('DEBUG [FCM]: Permission status: ${settings.authorizationStatus}');

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          String? token = await messaging.getToken();
          if (token != null) {
            print('DEBUG [FCM]: Token generated successfully: ${token.substring(0, 10)}...');
            await repo.updateFcmToken(token);
            print('DEBUG [FCM]: Token successfully updated on backend.');
          } else {
            print('DEBUG [FCM]: Token is null - ensure google-services.json is correct.');
          }
        } else {
          print('DEBUG [FCM]: Notification permissions were NOT granted.');
        }
      } else {
        print('DEBUG [FCM]: Skipping setup because platform is Web.');
      }
    } catch (e) {
      print('ERROR [FCM]: Failed to setup push notifications: $e');
    }
  }

  Future<void> login(String username, String password) async {
    print('AuthNotifier.login: attempting for username=$username');
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(username, password);
      print('AuthNotifier.login: Success with user ${user?.username}');
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
        // Set up push notifications
        _setupPushNotifications(repo);
      } else {
        print('AuthNotifier.login: User is null');
        state = AuthState.error('Bilinmeyen bir hata oluştu.');
      }
    } catch (e) {
      print('AuthNotifier.login ERROR: \$e');
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.register(username, email, password);
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
        // Setup push notifications
        _setupPushNotifications(repo);
      } else {
        state = AuthState.error('Bilinmeyen bir hata oluştu.');
      }
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = AuthState.unauthenticated();
  }

  Future<void> forgotPassword(String email) async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.forgotPassword(email);
      state = AuthState.unauthenticated(); // Return to unauthenticated to show the form again, ideally show a success message via a different mechanism
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.resetPassword(token, newPassword);
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
