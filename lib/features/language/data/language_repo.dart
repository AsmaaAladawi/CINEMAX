import 'package:flutter_application_1/core/navigation/option_model.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepo {
  final ApiService _api;
  LanguageRepo(this._api);

  static const _key = 'language';

  Future<List<OptionModel>> getLanguages() => _api.getLanguages();

  Future<String> getSelected() async =>
      (await SharedPreferences.getInstance()).getString(_key) ?? 'en';

  Future<void> save(String id) async =>
      (await SharedPreferences.getInstance()).setString(_key, id);
}