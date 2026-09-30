import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wishlist_item.dart';

class WishlistRepo {
  static const _key = 'wishlist';

  Future<List<WishlistItem>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_key) ?? [];
      return raw.map((e) => WishlistItem.fromJson(jsonDecode(e))).toList();
    } catch (e) {
      debugPrint('Wishlist load failed: $e');
      return [];
    }
  }

  Future<void> save(List<WishlistItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _key,
        items.map((e) => jsonEncode(e.toJson())).toList(),
      );
    } catch (e) {
      debugPrint('Wishlist save failed: $e');
    }
  }
}