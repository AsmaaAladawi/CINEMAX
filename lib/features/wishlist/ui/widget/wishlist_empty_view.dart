import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

class WishlistEmptyView extends StatelessWidget {
  const WishlistEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard_rounded, size: 72, color: AppColors.accent),
            SizedBox(height: 16),
            Text('There Is No Movie Yet!',
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
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