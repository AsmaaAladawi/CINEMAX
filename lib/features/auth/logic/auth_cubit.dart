import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_application_1/features/auth/logic/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _repo;
  AuthCubit(this._repo) : super(const AuthInitial());

  Future<void> login({required String email, required String password}) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return _fail('Please enter your email and password');
    }
    return _run(
      () => _repo.login(email: email, password: password),
      AuthAction.signedIn,
    );
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      return _fail('Please fill in all fields');
    }
    return _run(
      () => _repo.signUp(fullName: fullName, email: email, password: password),
      AuthAction.signedIn,
    );
  }

  Future<void> sendPasswordReset(String email) {
    if (email.trim().isEmpty) return _fail('Please enter your email');
    return _run(
      () => _repo.sendPasswordReset(email: email),
      AuthAction.passwordResetSent,
    );
  }

  Future<void> signInWithGoogle() =>
      _run(_repo.signInWithGoogle, AuthAction.signedIn);

  Future<void> signInWithFacebook() =>
      _run(_repo.signInWithFacebook, AuthAction.signedIn);

  Future<void> _fail(String message) async => emit(AuthFailure(message));

  Future<void> _run(Future<void> Function() action, AuthAction onSuccess) async {
    emit(const AuthLoading());
    try {
      await action();
      if (!isClosed) emit(AuthSuccess(onSuccess));
    } on AuthException catch (e) {
      if (isClosed) return;
      // Cancelled by the user: go back to idle silently.
      emit(e.cancelled ? const AuthInitial() : AuthFailure(e.message));
    } catch (_) {
      if (!isClosed) emit(AuthFailure('Something went wrong, please try again'));
    }
  }
}
