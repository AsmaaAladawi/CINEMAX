import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/navigation/go_home.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/features/auth/logic/auth_cubit.dart';
import 'package:flutter_application_1/features/auth/logic/auth_state.dart';

/// Wrap every auth page with this. It handles the common reactions once:
/// failure -> red snackbar, signed in -> Home, reset email sent -> snackbar + back.
class AuthListener extends StatelessWidget {
  final Widget child;
  const AuthListener({super.key, required this.child});

  void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthFailure(:final message):
            _show(context, message, AppColors.red);
          case AuthSuccess(action: AuthAction.signedIn):
            goToHome(context);
          case AuthSuccess(action: AuthAction.passwordResetSent):
            _show(context, 'Password reset link sent to your email',
                AppColors.accent);
            Navigator.pop(context);
          default:
            break;
        }
      },
      child: child,
    );
  }
}
