import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/features/auth/logic/auth_cubit.dart';
import 'package:flutter_application_1/features/auth/logic/auth_state.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_listener.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const AuthListener(child: _ResetPasswordView()),
      );
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView();

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _emailController = TextEditingController();

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().sendPasswordReset(_emailController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = context.select((AuthCubit c) => c.state is AuthLoading);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(title: 'Reset Password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Recover your account password',
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Send Reset Link',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
