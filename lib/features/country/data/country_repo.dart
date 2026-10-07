import 'package:flutter_application_1/core/networking/api_constants.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/core/selection/option_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryRepo {
  final ApiService _api;
  CountryRepo(this._api);

  static const _key = 'country';

  Future<List<OptionModel>> getCountries() async {
    final list = await _api.getList(ApiConstants.countries);
    return list
        .map<OptionModel>((e) => OptionModel(
            id: e['iso_3166_1'] as String, label: e['english_name'] as String))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  Future<String> getSelected() async =>
      (await SharedPreferences.getInstance()).getString(_key) ?? 'US';

  Future<void> save(String id) async =>
      (await SharedPreferences.getInstance()).setString(_key, id);
}