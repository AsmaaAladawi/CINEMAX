import 'package:flutter_application_1/core/navigation/option_model.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryRepo {
  final ApiService _api;
  CountryRepo(this._api);

  static const _key = 'country';

  Future<List<OptionModel>> getCountries() => _api.getCountries();

  Future<String> getSelected() async =>
      (await SharedPreferences.getInstance()).getString(_key) ?? 'US';

  Future<void> save(String id) async =>
      (await SharedPreferences.getInstance()).setString(_key, id);
}