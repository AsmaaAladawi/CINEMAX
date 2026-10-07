import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRepo {
  static const _key = 'notifications_enabled';

  Future<bool> getEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_key) ?? true;

  Future<void> setEnabled(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_key, v);
}