import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentPage;
  final int count;

  const OnboardingIndicator({
    super.key,
    required this.currentPage,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 32 : 10,
          height: 10,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF12CDD9).withValues(alpha: isActive ? 1 : 0.4),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}