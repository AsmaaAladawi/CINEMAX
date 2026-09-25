import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    }
  }

  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await credential.user?.updateDisplayName(fullName.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    }
  }

  Future<String?> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'تم إلغاء تسجيل الدخول';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return 'حدث خطأ أثناء تسجيل الدخول بجوجل: $e';
    }
  }

  Future<String?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        return 'تم إلغاء تسجيل الدخول';
      }

      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return 'حدث خطأ أثناء تسجيل الدخول بفيسبوك: $e';
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'هذا البريد مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جدًا';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة';
      case 'account-exists-with-different-credential':
        return 'يوجد حساب بنفس البريد مسجل بطريقة تسجيل دخول مختلفة';
      case 'network-request-failed':
        return 'تأكد من اتصالك بالإنترنت';
      default:
        return 'حدث خطأ، حاول مرة أخرى';
    }
  }
}