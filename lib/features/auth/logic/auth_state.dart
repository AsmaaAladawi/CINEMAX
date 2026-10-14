/// What just succeeded - the UI decides what to do with it.
enum AuthAction { signedIn, passwordResetSent }

// NOTE: intentionally NOT Equatable. These states are one-shot events
// (show a snackbar / navigate), so two failures with the same message in a
// row must still both reach the listener.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthAction action;
  AuthSuccess(this.action);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
