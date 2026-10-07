import 'package:flutter/painting.dart';
import 'package:flutter_application_1/core/networking/api_constants.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/profile/data/model/profile_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/home/data/models/user_model.dart';

class ProfileRepo {
  final ApiService _api;
  ProfileRepo(this._api);

  static const _kName = 'profile_name';
  static const _kEmail = 'profile_email';
  static const _kPhone = 'profile_phone';

  Future<ProfileModel> getProfile() async {
    final user = UserModel.fromJson(await _api.get(ApiConstants.account));
    final prefs = await SharedPreferences.getInstance();
    return ProfileModel(
      name: prefs.getString(_kName) ?? user.name,
      email: prefs.getString(_kEmail) ?? '',
      phone: prefs.getString(_kPhone) ?? '',
      avatarUrl: user.avatarUrl,
    );
  }

  Future<void> saveProfile(ProfileModel p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, p.name);
    await prefs.setString(_kEmail, p.email);
    await prefs.setString(_kPhone, p.phone);
  }

  Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kName);
    await prefs.remove(_kEmail);
    await prefs.remove(_kPhone);
    //await FirebaseAuth.instance.signOut();
  }
}