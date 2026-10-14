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

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const AuthListener(child: _SignUpView()),
      );
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Please accept the Terms and Privacy Policy'),
          backgroundColor: AppColors.red,
        ));
      return;
    }
    context.read<AuthCubit>().signUp(
          fullName: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = context.select((AuthCubit c) => c.state is AuthLoading);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(title: 'Sign Up'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Let's get started",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'The latest movies and series are here',
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
              const SizedBox(height: 32),
              CustomTextField(label: 'Full Name', controller: _nameController),
              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.accent,
                    onChanged: (value) =>
                        setState(() => _agreedToTerms = value ?? false),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms and Services',
                              style: TextStyle(color: AppColors.accent),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Sign Up',
                isLoading: isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
