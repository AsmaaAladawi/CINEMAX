import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/home/ui/widgets/actors_row.dart';
import 'package:flutter_application_1/features/movie_detail/logic/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/bottom_nav_handler.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../wishlist/data/models/wishlist_item.dart';
import '../../../wishlist/logic/wishlist_cubit.dart';
import '../../data/repos/movie_detail_repo.dart';
import '../../logic/movie_detail_cubit.dart';
import '../widgets/share_sheet.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  static Route route(int movieId) => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              MovieDetailCubit(MovieDetailRepo(ApiService()))..load(movieId),
          child: MovieDetailPage(movieId: movieId),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (i) => handleBottomNav(context, current: 0, index: i),
      ),
      body: SafeArea(
        child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) => switch (state) {
            MovieDetailLoading() => const Column(children: [
                PageHeader(title: ''),
                Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: AppColors.accent))),
              ]),
            MovieDetailError(:final message) => Column(children: [
                const PageHeader(title: ''),
                Expanded(
                  child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<MovieDetailCubit>().load(movieId),
                        child: const Text('Retry'),
                      ),
                    ]),
                  ),
                ),
              ]),
            MovieDetailSuccess() => _Content(state: state),
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final MovieDetailSuccess state;
  const _Content({required this.state});

  @override
  Widget build(BuildContext context) {
    final d = state.detail;
    final width = MediaQuery.of(context).size.width;
    const sectionTitle =
        TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

    return Column(
      children: [
        PageHeader(
          title: d.title,
          trailing: BlocBuilder<WishlistCubit, List<WishlistItem>>(
            bloc: WishlistCubit.instance,
            builder: (_, items) {
              final fav = items.any((e) => e.id == d.id);
              return GestureDetector(
                onTap: () =>
                    WishlistCubit.instance.toggle(WishlistItem.fromDetail(d)),
                child: Icon(
                  fav ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.red,
                  size: 22,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              Center(
                child: SizedBox(
                  width: width * 0.6,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(imageUrl: d.posterUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Info(icon: Icons.calendar_today_outlined, text: d.year),
                  const _Divider(),
                  _Info(icon: Icons.access_time_rounded, text: d.duration),
                  const _Divider(),
                  _Info(icon: Icons.movie_outlined, text: d.genre),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.orange),
                  const SizedBox(width: 4),
                  Text(d.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _SquareButton(icon: Icons.download_rounded, onTap: () {}),
                  const SizedBox(width: 12),
                  _SquareButton(
                    icon: Icons.share_outlined,
                    onTap: () =>
                        showShareSheet(context, title: d.title, movieId: d.id),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Story Line', style: sectionTitle),
              const SizedBox(height: 8),
              _StoryLine(text: d.overview),
              if (state.cast.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('Cast and Crew', style: sectionTitle),
                const SizedBox(height: 12),
                ActorsRow(actors: state.cast),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Info({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: AppColors.grey),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
    ]);
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: AppColors.grey.withOpacity(0.4),
      );
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SquareButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: AppColors.accent, size: 22),
      ),
    );
  }
}

class _StoryLine extends StatefulWidget {
  final String text;
  const _StoryLine({required this.text});

  @override
  State<_StoryLine> createState() => _StoryLineState();
}

class _StoryLineState extends State<_StoryLine> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      return const Text('No overview available.',
          style: TextStyle(color: AppColors.grey, fontSize: 12));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : 4,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Less' : 'More',
              style: const TextStyle(
                  color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}