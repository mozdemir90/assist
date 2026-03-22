import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';
import 'auth_state.dart';
import '../../sync/presentation/providers/sync_provider.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/logger/app_logger.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkInitialAuth();
    return const AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    state = const AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final user = await repo.checkAuth();
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
      } else {
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
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.register(username, email, password);
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
      appLogger.e('Unexpected register failure', error: e, stackTrace: st);
      state = const AuthState.error('Kayıt sırasında beklenmedik bir hata oluştu.');
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState.unauthenticated();
  }
}
