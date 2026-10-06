import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../data/movie_model.dart';
import '../../movie_detail/ui/pages/movie_detail_page.dart';

class SearchMovieItem extends StatelessWidget {
  final MovieModel movie;
  final String genre;
  const SearchMovieItem({super.key, required this.movie, required this.genre});

  @override
  Widget build(BuildContext context) {
    final year = movie.releaseDate.length >= 4 ? movie.releaseDate.substring(0, 4) : '-';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(context, MovieDetailPage.route(movie.id)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(imageUrl: movie.posterUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star, size: 12, color: AppColors.orange),
                        const SizedBox(width: 3),
                        Text(movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                                color: AppColors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.calendar_today_outlined, text: year),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.local_movies_outlined,
                    text: genre.isEmpty ? 'Movie' : '$genre  |  Movie',
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: AppColors.grey),
      const SizedBox(width: 6),
      Flexible(
        child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.grey, fontSize: 12)),
      ),
    ]);
  }
}