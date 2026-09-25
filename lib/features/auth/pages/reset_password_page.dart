import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleNext() async {
    setState(() => _isLoading = true);

    final error = await _authService.sendPasswordReset(
      email: _emailController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رابط استرجاع كلمة المرور لبريدك'),
          backgroundColor: Color(0xFF12CDD9),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
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
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Recover your account password',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  color: Color(0xFF92929D),
                ),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 8),

              PrimaryButton(
                label: 'Next',
                isLoading: _isLoading,
                onPressed: _handleNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}