import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك وافقي على الشروط والأحكام'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.signUp(
      fullName: _nameController.text,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الحساب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomePage()),
      // );
    }
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

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
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
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'The latest movies and series are here',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  color: Color(0xFF92929D),
                ),
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
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: const Color(0xFF12CDD9),
                    onChanged: (value) {
                      setState(() => _agreedToTerms = value ?? false);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Color(0xFF92929D),
                          ),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms and Services',
                              style: TextStyle(color: Color(0xFF12CDD9)),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: Color(0xFF12CDD9)),
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
                isLoading: _isLoading,
                onPressed: _handleSignUp,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}