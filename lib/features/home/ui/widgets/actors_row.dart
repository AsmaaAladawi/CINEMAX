import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import '../../../search/data/model/actor_model.dart';

class ActorsRow extends StatelessWidget {
  final List<ActorModel> actors;
  const ActorsRow({super.key, required this.actors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final actor = actors[i];
          return SizedBox(
            width: 64,
            child: Column(
              children: [
                ClipOval(
                  child: actor.profileUrl == null
                      ? Container(
                          width: 56,
                          height: 56,
                          color: AppColors.surface,
                          child: const Icon(Icons.person, color: AppColors.grey),
                        )
                      : CachedNetworkImage(
                          imageUrl: actor.profileUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 6),
                Text(actor.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }
}