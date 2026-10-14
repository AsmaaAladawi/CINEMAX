import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/features/home/logic/home_cubit.dart';
import 'package:flutter_application_1/features/home/ui/pages/home_page.dart';

class HomeEntry extends StatelessWidget {
  const HomeEntry({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<HomeCubit>()..loadHome(),
        child: const HomePage(),
      );
}


void goToHome(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const HomeEntry()),
    (_) => false,
  );
}
