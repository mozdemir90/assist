import '../../domain/user_model.dart';

abstract class AuthState {
  const AuthState();

  factory AuthState.initial() = AuthStateInitial;
  factory AuthState.loading() = AuthStateLoading;
  factory AuthState.authenticated(User user) = AuthStateAuthenticated;
  factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  factory AuthState.error(String message) = AuthStateError;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(User user)? authenticated,
    T Function()? unauthenticated,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    if (this is AuthStateInitial && initial != null) return initial();
    if (this is AuthStateLoading && loading != null) return loading();
    if (this is AuthStateAuthenticated && authenticated != null) return authenticated((this as AuthStateAuthenticated).user);
    if (this is AuthStateUnauthenticated && unauthenticated != null) return unauthenticated();
    if (this is AuthStateError && error != null) return error((this as AuthStateError).message);
    return orElse();
  }
}

class AuthStateInitial extends AuthState { const AuthStateInitial(); }
class AuthStateLoading extends AuthState { const AuthStateLoading(); }
class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);
}
class AuthStateUnauthenticated extends AuthState { const AuthStateUnauthenticated(); }
class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}
