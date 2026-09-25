import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/onboarding/onboarding_model.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(model.image, fit: BoxFit.cover),
          ),
        ),

        const SizedBox(height: 32),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.15),
          child: Text(
            model.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.15),
          child: Text(
            model.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.0,
              letterSpacing: 0.12,
              color: Color(0xFF92929D),
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}