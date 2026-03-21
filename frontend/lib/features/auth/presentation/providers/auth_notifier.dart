import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import 'auth_state.dart';
import '../../../sync/presentation/providers/sync_provider.dart';

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
      if (user != null) {
        state = AuthState.authenticated(user);
        // Trigger background sync
        ref.read(syncProvider).syncAll();
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
}
