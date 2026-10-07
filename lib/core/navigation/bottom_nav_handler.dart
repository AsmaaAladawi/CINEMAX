import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/search/ui/page/search_page.dart';
import '../../features/wishlist/ui/pages/wishlist_page.dart';

void handleBottomNav(
  BuildContext context, {
  required int current,
  required int index,
}) {
  if (index == current) return;
  switch (index) {
    case 0:
      Navigator.popUntil(context, (route) => route.isFirst);
    case 1:
      Navigator.push(context, SearchPage.route());
    case 2:
      Navigator.push(context, WishlistPage.route());
  }
}