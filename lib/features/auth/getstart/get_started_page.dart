import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/features/auth/login/login_page.dart';
import 'package:flutter_application_1/features/auth/signup/sign_up_page.dart';
import 'package:flutter_application_1/features/auth/logic/auth_cubit.dart';
import 'package:flutter_application_1/features/auth/logic/auth_state.dart';
import 'package:flutter_application_1/features/auth/widgets/auth_listener.dart';
import 'package:flutter_application_1/features/auth/widgets/primary_button.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const AuthListener(child: _GetStartedView()),
      );
}

class _GetStartedView extends StatelessWidget {
  const _GetStartedView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = context.read<AuthCubit>();
    final isLoading = context.select((AuthCubit c) => c.state is AuthLoading);

    return Scaffold(
      backgroundColor: AppColors.background,
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
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    letterSpacing: 0.12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sign up to watch the latest\nmovies and series',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.12,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                PrimaryButton(
                  label: 'Sign Up',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text.rich(
                    TextSpan(
                      style: TextStyle(
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
                            color: AppColors.orange,
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
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.12,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  SizedBox(
                    height: size.width * 0.18,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(
                        asset: 'assets/Google.png',
                        onTap: cubit.signInWithGoogle,
                      ),
                      const SizedBox(width: 20),
                      _SocialButton(
                        asset: 'assets/Facebook.png',
                        onTap: cubit.signInWithFacebook,
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

class _SocialButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  const _SocialButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final side = MediaQuery.of(context).size.width * 0.18;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: side, height: side, child: Image.asset(asset)),
    );
  }
}
