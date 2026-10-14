import 'package:flutter/painting.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_application_1/features/profile/data/model/profile_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final ApiService _api;
  final AuthRepo _auth;
  ProfileRepo(this._api, this._auth);

  static const _kName = 'profile_name';
  static const _kEmail = 'profile_email';
  static const _kPhone = 'profile_phone';

  Future<ProfileModel> getProfile() async {
    final user = await _api.getUser();
    final prefs = await SharedPreferences.getInstance();
    final fb = _auth.currentUser;
    final fbName = fb?.displayName;
    return ProfileModel(
      name: prefs.getString(_kName) ??
          ((fbName != null && fbName.isNotEmpty) ? fbName : user.name),
      email: prefs.getString(_kEmail) ?? fb?.email ?? '',
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
    await clearCache();
    await _auth.signOut();
  }
}