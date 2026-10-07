import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';

class EmptySearchView extends StatelessWidget {
  const EmptySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 72, color: AppColors.accent),
            SizedBox(height: 16),
            Text('We Are Sorry, We Can\nNot Find The Movie :(',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Find your movie by Type title,\ncategories, years, etc',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}