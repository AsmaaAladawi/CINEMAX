import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/home/data/repos/home_repo.dart';
import 'package:flutter_application_1/features/home/logic/home_cubit.dart';
import 'package:flutter_application_1/features/home/ui/pages/home_page.dart';
import '../services/auth_service.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../newpass/reset_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  StreamSubscription<User?>? _authSub;
  bool _navigated = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // أول ما Firebase يقول في يوزر مسجّل، نروح للهوم
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint('authStateChanges: ${user?.email}');
      if (user != null) _goHome();
    });
  }

  void _goHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    debugPrint('navigating to home');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => HomeCubit(HomeRepo(ApiService()))..loadHome(),
          child: const HomePage(),
        ),
      ),
      (route) => false,
    );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    String? error;
    try {
      error = await _authService
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          )
          .timeout(const Duration(seconds: 15));
      debugPrint('login result: $error');
    } catch (e) {
      debugPrint('login exception: $e');
      // لو Firebase سجّل الدخول فعلًا رغم الـ exception، كمّلي للهوم
      if (FirebaseAuth.instance.currentUser != null) {
        _goHome();
        return;
      }
      error = e.toString();
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    _goHome();
  }

  @override
  void dispose() {
    _authSub?.cancel();
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