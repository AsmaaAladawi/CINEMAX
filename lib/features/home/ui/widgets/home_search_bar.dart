import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  const HomeSearchBar({super.key, this.onTap, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 16, color: AppColors.grey),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Search a title..',
                  style: TextStyle(color: AppColors.grey, fontSize: 12)),
            ),
            Container(width: 1, height: 16, color: AppColors.grey.withOpacity(0.4)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFilterTap,
              child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}