import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/core/selection/option_list_page.dart';
import 'package:flutter_application_1/core/selection/selection_cubit.dart';
import 'package:flutter_application_1/features/country/logic/country_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryPage extends StatelessWidget {
  const CountryPage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider<SelectionCubit>(
          create: (_) => sl<CountryCubit>()..load(),
          child: const CountryPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const OptionListPage(
        title: 'Country',
        suggestedTitle: 'Suggested Countries',
        otherTitle: 'Other countries',
        suggestedIds: ['US', 'GB', 'EG'],
      );
}