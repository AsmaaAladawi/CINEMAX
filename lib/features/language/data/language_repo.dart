import 'package:flutter_application_1/core/networking/api_constants.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/core/selection/option_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepo {
  final ApiService _api;
  LanguageRepo(this._api);

  static const _key = 'language';

  Future<List<OptionModel>> getLanguages() async {
    final list = await _api.getList(ApiConstants.languages);
    return list
        .where((e) => e['iso_639_1'] != 'xx' && (e['english_name'] as String).isNotEmpty)
        .map<OptionModel>((e) => OptionModel(
            id: e['iso_639_1'] as String, label: e['english_name'] as String))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  Future<String> getSelected() async =>
      (await SharedPreferences.getInstance()).getString(_key) ?? 'en';

  Future<void> save(String id) async =>
      (await SharedPreferences.getInstance()).setString(_key, id);
}