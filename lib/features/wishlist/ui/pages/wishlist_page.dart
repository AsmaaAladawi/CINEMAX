import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../movie_detail/ui/pages/movie_detail_page.dart';
import '../../data/models/wishlist_item.dart';
import '../../logic/wishlist_cubit.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static Route route() => MaterialPageRoute(builder: (_) => const WishlistPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Wishlist'),
            Expanded(
              child: BlocBuilder<WishlistCubit, List<WishlistItem>>(
                bloc: WishlistCubit.instance,
                builder: (context, items) {
                  if (items.isEmpty) return const _EmptyView();
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _WishlistCard(item: items[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final WishlistItem item;
  const _WishlistCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MovieDetailPage.route(item.id)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 110,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.genre,
                      style: const TextStyle(color: AppColors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Text('Movie',
                        style: TextStyle(color: AppColors.grey, fontSize: 10)),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 12, color: AppColors.orange),
                    const SizedBox(width: 2),
                    Text(item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => WishlistCubit.instance.remove(item.id),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.favorite, color: AppColors.red, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard_rounded, size: 72, color: AppColors.accent),
            SizedBox(height: 16),
            Text('There Is No Movie Yet!',
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Find your movie by Type title,\ncategories, years, etc',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}