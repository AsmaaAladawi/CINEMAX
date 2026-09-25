import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'reset_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final error = await _authService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomePage()),
      // );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: const AuthAppBar(title: 'Login'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Hi, Tiffany',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Welcome back! Please enter your details.',
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

              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF12CDD9),
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              PrimaryButton(
                label: 'Login',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}