import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/core/selection/option_list_page.dart';
import 'package:flutter_application_1/core/selection/selection_cubit.dart';
import 'package:flutter_application_1/features/language/logic/language_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider<SelectionCubit>(
          create: (_) => sl<LanguageCubit>()..load(),
          child: const LanguagePage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const OptionListPage(
        title: 'Language',
        suggestedTitle: 'Suggested Languages',
        otherTitle: 'Other languages',
        suggestedIds: ['en', 'ar', 'id'],
      );
}