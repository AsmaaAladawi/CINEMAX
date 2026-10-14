import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/themes/app_colors.dart';

double _s(BuildContext context, double value) {
  final width = MediaQuery.sizeOf(context).width;
  return value * (width / 390).clamp(0.85, 1.3);
}

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
        insetPadding: EdgeInsets.symmetric(horizontal: _s(ctx, 32)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(_s(ctx, 24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Share to',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: _s(ctx, 16),
                              fontWeight: FontWeight.w600)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Icon(Icons.close,
                          color: AppColors.grey, size: _s(ctx, 24)),
                    ),
                  ],
                ),
                SizedBox(height: _s(ctx, 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareButton(
                      onTap: () => run(() => openApp(Uri.parse(
                          'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(link)}'))),
                      child: Text('f',
                          style: TextStyle(
                              color: const Color(0xFF1877F2),
                              fontSize: _s(ctx, 22),
                              fontWeight: FontWeight.w800)),
                    ),
                    _ShareButton(
                      onTap: () => run(systemShare),
                      child: Icon(Icons.camera_alt_outlined,
                          size: _s(ctx, 24), color: const Color(0xFFE1306C)),
                    ),
                    _ShareButton(
                      onTap: () => run(() => openApp(Uri.parse(
                          'fb-messenger://share?link=${Uri.encodeComponent(link)}'))),
                      child: Icon(Icons.chat_bubble_outline,
                          size: _s(ctx, 24), color: const Color(0xFF0084FF)),
                    ),
                    _ShareButton(
                      onTap: () => run(systemShare),
                      child: Icon(Icons.send_rounded,
                          size: _s(ctx, 24), color: AppColors.accent),
                    ),
                  ],
                ),
              ],
            ),
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
    final size = _s(context, 48);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
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