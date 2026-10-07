import 'package:flutter_application_1/core/selection/selection_cubit.dart';
import 'package:flutter_application_1/features/language/data/language_repo.dart';

class LanguageCubit extends SelectionCubit {
  LanguageCubit(LanguageRepo r) : super(r.getLanguages, r.getSelected, r.save);
}