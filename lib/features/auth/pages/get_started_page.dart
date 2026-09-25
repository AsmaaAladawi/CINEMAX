import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/pages/sign_up_page.dart';
import '../services/auth_service.dart'; 

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = AuthService();

    void showMessage(String message, {bool isError = true}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.08),

                SizedBox(
                  width: size.width * 0.23,
                  height: size.width * 0.23,
                  child: Image.asset('assets/app_icon.png'),
                ),

                const SizedBox(height: 20),

                const Text(
                  'CINEMAX',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    letterSpacing: 0.12,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Enter your registered\nPhone Number to Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.12,
                    color: const Color(0xFF92929D),
                  ),
                ),

                SizedBox(height: size.height * 0.07),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF12CDD9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: 'I already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFB9400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                const Text(
                  'Or Sign up with',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.12,
                    color: Color(0xFF92929D),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        debugPrint('===== Google button tapped =====');
                        final error = await authService.signInWithGoogle();
                        debugPrint('===== Google result: $error =====');
                        if (!context.mounted) return;
                        if (error != null) {
                          showMessage(error);
                        } else {
                          showMessage('تم تسجيل الدخول بنجاح', isError: false);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                        }
                      },
                      child: SizedBox(
                        width: size.width * 0.18,
                        height: size.width * 0.18,
                        child: Image.asset('assets/Google.png'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () async {
                        debugPrint('===== Facebook button tapped =====');
                        final error = await authService.signInWithFacebook();
                        debugPrint('===== Facebook result: $error =====');
                        if (!context.mounted) return;
                        if (error != null) {
                          showMessage(error);
                        } else {
                          showMessage('تم تسجيل الدخول بنجاح', isError: false);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                        }
                      },
                      child: SizedBox(
                        width: size.width * 0.18,
                        height: size.width * 0.18,
                        child: Image.asset('assets/Facebook.png'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}