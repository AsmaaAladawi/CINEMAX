import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.search_rounded, 'Search'),
    (Icons.download_rounded, 'Download'),
    (Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Color(0x1A92929D))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_items.length, (i) {
            final selected = i == currentIndex;
            final (icon, label) = _items[i];
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: selected ? 14 : 8, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  Icon(icon, size: 22, color: selected ? AppColors.accent : AppColors.grey),
                  if (selected) ...[
                    const SizedBox(width: 6),
                    Text(label,
                        style: const TextStyle(
                            color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }
}