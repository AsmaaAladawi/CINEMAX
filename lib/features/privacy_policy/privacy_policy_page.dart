import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/core/widgets/page_header.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static Route route() =>
      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());

  static const _lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget ornare quam vel '
      'facilisis feugiat amet sagittis arcu, tortor. Sapien, consequat ultrices morbi '
      'orci semper sit nulla. Leo auctor ut etiam est, amet aliquet ut vivamus. Odio '
      'vulputate est id tincidunt fames.';

  static const _sections = <(String, List<String>)>[
    ('Terms', [_lorem, _lorem]),
    ('Changes to the Service and/or Terms:', [_lorem, _lorem]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Privacy Policy'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                children: [
                  for (final (title, paragraphs) in _sections) ...[
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    for (final p in paragraphs) ...[
                      Text(p,
                          style: const TextStyle(
                              color: AppColors.grey, fontSize: 12, height: 1.6)),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}