
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';

import '../../../search/data/model/actor_model.dart';

class ActorsRow extends StatelessWidget {
  final List<ActorModel> actors;

  const ActorsRow({
    super.key,
    required this.actors,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = (width / 390).clamp(0.85, 1.3);

    final imageSize = 56.0 * scale;
    final itemWidth = 76.0 * scale;

    return SizedBox(
      height: 112 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: actors.length,
        separatorBuilder: (_, __) => SizedBox(width: 16 * scale),
        itemBuilder: (context, i) {
          final actor = actors[i];

          return SizedBox(
            width: itemWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: actor.profileUrl == null
                        ? Container(
                            color: AppColors.surface,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.person,
                              color: AppColors.grey,
                              size: 28 * scale,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: actor.profileUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppColors.surface,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.accent,
                                strokeWidth: 2,
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.surface,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.person,
                                color: AppColors.grey,
                                size: 28 * scale,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 6 * scale),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    actor.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10 * scale,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
