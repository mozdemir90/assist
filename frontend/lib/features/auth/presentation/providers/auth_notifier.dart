import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';
<<<<<<< Updated upstream
import '../../domain/user_model.dart';
import 'auth_state.dart';
import '../../../sync/presentation/providers/sync_provider.dart';
=======
import 'auth_state.dart';
import '../../sync/presentation/providers/sync_provider.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/logger/app_logger.dart';
>>>>>>> Stashed changes

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkInitialAuth();
<<<<<<< Updated upstream
    return AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    state = AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final isAuth = await repo.isAuthenticated();
      if (isAuth) {
        // Ideally we would fetch the user profile here with the token
        // For now, we mock an authenticated state if token exists
        state = AuthState.authenticated(User(id: 'local', username: 'User', email: '...', isActive: true));
        // Trigger background sync
        ref.read(syncProvider).syncAll();
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login(String username, String password) async {
    print('AuthNotifier.login: attempting for username=\$username');
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(username, password);
      print('AuthNotifier.login: Success with user \${user?.username}');
=======
    return const AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    state = const AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final user = await repo.checkAuth();
>>>>>>> Stashed changes
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
      } else {
<<<<<<< Updated upstream
        print('AuthNotifier.login: User is null');
        state = AuthState.error('Bilinmeyen bir hata oluştu.');
      }
    } catch (e) {
      print('AuthNotifier.login ERROR: \$e');
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
=======
        state = const AuthState.unauthenticated();
      }
    } catch (e, st) {
      appLogger.e('Initial auth check failed', error: e, stackTrace: st);
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String username, String password) async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(username, password);
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
      } else {
        state = const AuthState.error('Bilinmeyen bir hata oluştu.');
      }
    } on CustomAppException catch (e) {
      state = AuthState.error(e.message);
    } catch (e, st) {
      appLogger.e('Unexpected login failure', error: e, stackTrace: st);
      state = const AuthState.error('Giriş sırasında beklenmedik bir hata oluştu.');
>>>>>>> Stashed changes
    }
  }

  Future<void> register(String username, String email, String password) async {
<<<<<<< Updated upstream
    state = AuthState.loading();
=======
    state = const AuthState.loading();
>>>>>>> Stashed changes
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.register(username, email, password);
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
      } else {
<<<<<<< Updated upstream
        state = AuthState.error('Bilinmeyen bir hata oluştu.');
      }
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
=======
        state = const AuthState.error('Bilinmeyen bir hata oluştu.');
      }
    } on CustomAppException catch (e) {
      state = AuthState.error(e.message);
    } catch (e, st) {
      appLogger.e('Unexpected register failure', error: e, stackTrace: st);
      state = const AuthState.error('Kayıt sırasında beklenmedik bir hata oluştu.');
>>>>>>> Stashed changes
    }
  }

  Future<void> logout() async {
<<<<<<< Updated upstream
    state = AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = AuthState.unauthenticated();
=======
    state = const AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState.unauthenticated();
>>>>>>> Stashed changes
  }
}
