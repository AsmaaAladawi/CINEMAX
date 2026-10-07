import 'package:flutter_application_1/core/selection/selection_cubit.dart';
import 'package:flutter_application_1/features/country/data/country_repo.dart';

class CountryCubit extends SelectionCubit {
  CountryCubit(CountryRepo r) : super(r.getCountries, r.getSelected, r.save);
}