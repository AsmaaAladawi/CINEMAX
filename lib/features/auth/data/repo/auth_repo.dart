import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String message;

  final bool cancelled;

  const AuthException(this.message, {this.cancelled = false});

  @override
  String toString() => message;
}

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn.instance; // google_sign_in 7.x
  bool _googleReady = false;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> login({required String email, required String password}) async {
    try {
      await _guard(() => _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .timeout(const Duration(seconds: 15)));
    } on TimeoutException {
      // Firebase sometimes signs the user in but never completes the future.
      if (!isLoggedIn) {
        throw const AuthException('Request timed out, please try again');
      }
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) =>
      _guard(() async {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        await credential.user?.updateDisplayName(fullName.trim());
      });

  Future<void> sendPasswordReset({required String email}) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> signInWithGoogle() => _guard(() async {
        if (!_googleReady) {
          // On Android you may need: initialize(serverClientId: 'WEB_CLIENT_ID')
          await _google.initialize();
          _googleReady = true;
        }
        if (!_google.supportsAuthenticate()) {
          throw const AuthException(
              'Google sign-in is not supported on this device');
        }
        try {
          final account = await _google.authenticate();
          final credential = GoogleAuthProvider.credential(
            idToken: account.authentication.idToken,
          );
          await _auth.signInWithCredential(credential);
        } on GoogleSignInException catch (e) {
          if (e.code == GoogleSignInExceptionCode.canceled) {
            throw const AuthException('Sign-in cancelled', cancelled: true);
          }
          throw AuthException(
              'Google sign-in failed: ${e.description ?? e.code.name}');
        }
      });

  Future<void> signInWithFacebook() => _guard(() async {
        final result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.cancelled) {
          throw const AuthException('Sign-in cancelled', cancelled: true);
        }
        if (result.status != LoginStatus.success ||
            result.accessToken == null) {
          throw AuthException(result.message ?? 'Facebook sign-in failed');
        }
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await _auth.signInWithCredential(credential);
      });

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      if (_googleReady) await _google.signOut();
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  /// Converts FirebaseAuthException into an AuthException with a readable message.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e.code));
    }
  }

  String _message(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password';
      case 'email-already-in-use':
        return 'This email is already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts, please try again later';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      case 'network-request-failed':
        return 'Check your internet connection';
      default:
        return 'Something went wrong, please try again';
    }
  }
}
