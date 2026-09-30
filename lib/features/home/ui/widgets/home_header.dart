import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/models/user_model.dart';

class HomeHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onFavoriteTap;
  const HomeHeader({super.key, required this.user, this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.avatarUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, ${user.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    letterSpacing: 0.12,
                  )),
              const SizedBox(height: 4),
              const Text("Let's stream your favorite movie",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: 0.12,
                  )),
            ],
          ),
        ),
        GestureDetector(
          onTap: onFavoriteTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.favorite, color: AppColors.red, size: 20),
          ),
        ),
      ],
    );
  }
}