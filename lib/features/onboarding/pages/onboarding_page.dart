import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/onboarding/model/onboarding_content.dart';
import 'package:flutter_application_1/features/onboarding/model/onboarding_model.dart';
import '../widgets/onboarding_indicator.dart';
import 'package:flutter_application_1/features/auth/getstart/get_started_page.dart'; // ⬅️ جديد

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnboardingModel> pages = const [
    OnboardingModel(
      image: 'assets/Onboarding1.png',
      title: 'Lorem ipsum dolor sit amet consecteur esplicit',
      subtitle: 'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.',
    ),
    OnboardingModel(
      image: 'assets/Onboarding2.png',
      title:'Lorem ipsum dolor sit amet consecteur esplicit',
      subtitle: 'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.',
    ),
    OnboardingModel(
      image: 'assets/Onboarding3.png',
      title: 'Lorem ipsum dolor sit amet consecteur esplicit',
      subtitle:'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.',
    ),
  ];

  void nextPage() {
    if (currentPage == pages.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedPage()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (context, index) =>
                    OnboardingContent(model: pages[index]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OnboardingIndicator(
                    currentPage: currentPage,
                    count: pages.length,
                  ),
                  InkWell(
                    onTap: nextPage,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF12CDD9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}