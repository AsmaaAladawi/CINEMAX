import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/core/navigation/go_home.dart';
import 'package:flutter_application_1/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_application_1/features/onboarding/pages/onboarding_page.dart';
import 'package:flutter_application_1/features/wishlist/logic/wishlist_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupDI();
  runApp(
    BlocProvider.value(
      value: sl<WishlistCubit>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinemax',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: const Color(0xFF1F1D2B),
      ),
      // Logged-in users skip onboarding and go straight to Home.
      home: sl<AuthRepo>().isLoggedIn
          ? const HomeEntry()
          : const OnboardingPage(),
    );
  }
}