import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/themes/app_colors.dart';

void showShareSheet(
  BuildContext context, {
  required String title,
  required int movieId,
}) {
  final link = 'https://www.themoviedb.org/movie/$movieId';
  final text = 'Check out "$title" 🎬\n$link';

  void systemShare() => SharePlus.instance.share(ShareParams(text: text));

  Future<void> openApp(Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) systemShare();
    } catch (_) {
      systemShare();
    }
  }

  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) {
      void run(VoidCallback action) {
        Navigator.pop(ctx);
        action();
      }

      return Dialog(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Share to',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, color: AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ShareButton(
                    onTap: () => run(() => openApp(Uri.parse(
                        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(link)}'))),
                    child: const Text('f',
                        style: TextStyle(
                            color: Color(0xFF1877F2),
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                  ),
                  _ShareButton(
                    onTap: () => run(systemShare),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: Color(0xFFE1306C)),
                  ),
                  _ShareButton(
                    onTap: () => run(() => openApp(Uri.parse(
                        'fb-messenger://share?link=${Uri.encodeComponent(link)}'))),
                    child: const Icon(Icons.chat_bubble_outline,
                        color: Color(0xFF0084FF)),
                  ),
                  _ShareButton(
                    onTap: () => run(systemShare),
                    child: const Icon(Icons.send_rounded, color: AppColors.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ShareButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _ShareButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}