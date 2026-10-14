

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/di/injection.dart';
import 'package:flutter_application_1/core/navigation/bottom_nav_handler.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/core/widgets/app_bottom_nav.dart';
import 'package:flutter_application_1/core/widgets/page_header.dart';
import 'package:flutter_application_1/features/home/ui/widgets/actors_row.dart';
import 'package:flutter_application_1/features/movie_detail/logic/movie_detail_cubit.dart';
import 'package:flutter_application_1/features/movie_detail/logic/movie_detail_state.dart';
import 'package:flutter_application_1/features/movie_detail/ui/widgets/share_sheet.dart';
import 'package:flutter_application_1/features/wishlist/data/models/wishlist_item.dart';
import 'package:flutter_application_1/features/wishlist/logic/wishlist_cubit.dart';
import 'package:flutter_application_1/features/wishlist/logic/wishlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

double _s(BuildContext context, double value) {
  final width = MediaQuery.sizeOf(context).width;
  return value * (width / 390).clamp(0.85, 1.3);
}

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  static Route route(int movieId) => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<MovieDetailCubit>()..load(movieId),
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
            MovieDetailLoading() => const Column(
                children: [
                  PageHeader(title: ''),
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            MovieDetailError(:final message) => Column(
                children: [
                  const PageHeader(title: ''),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<MovieDetailCubit>()
                                  .load(movieId),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    final width = MediaQuery.sizeOf(context).width;

    final sectionTitle = TextStyle(
      color: Colors.white,
      fontSize: _s(context, 14),
      fontWeight: FontWeight.w600,
    );

    final posterWidth = (width * 0.6).clamp(0.0, 320.0);

    return Column(
      children: [
        PageHeader(
          title: d.title,
          trailing: BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, wishlist) {
              final fav = wishlist.contains(d.id);

              return GestureDetector(
                onTap: () => context
                    .read<WishlistCubit>()
                    .toggle(WishlistItem.fromDetail(d)),
                child: Icon(
                  fav ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.red,
                  size: _s(context, 22),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              width * 0.06,
              _s(context, 8),
              width * 0.06,
              _s(context, 24),
            ),
            children: [
              Center(
                child: SizedBox(
                  width: posterWidth,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: d.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: _s(context, 24)),

              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: _s(context, 12),
                runSpacing: _s(context, 8),
                children: [
                  if (d.year.isNotEmpty)
                    _Info(
                      icon: Icons.calendar_today_outlined,
                      text: d.year,
                    ),
                  if (d.duration.isNotEmpty)
                    _Info(
                      icon: Icons.access_time_rounded,
                      text: d.duration,
                    ),
                  if (d.genre.isNotEmpty)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width * 0.88,
                      ),
                      child: _Info(
                        icon: Icons.movie_outlined,
                        text: d.genre,
                      ),
                    ),
                ],
              ),
              SizedBox(height: _s(context, 12)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: _s(context, 16),
                    color: AppColors.orange,
                  ),
                  SizedBox(width: _s(context, 4)),
                  Text(
                    d.voteAverage.toStringAsFixed(1),
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: _s(context, 12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _s(context, 20)),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: _s(context, 24),
                      ),
                      label: Text(
                        'Play',
                        style: TextStyle(
                          fontSize: _s(context, 14),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(_s(context, 48)),
                        shape: const StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: _s(context, 8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: _s(context, 10)),
                  _SquareButton(
                    icon: Icons.download_rounded,
                    onTap: () {},
                  ),
                  SizedBox(width: _s(context, 10)),
                  _SquareButton(
                    icon: Icons.share_outlined,
                    onTap: () => showShareSheet(
                      context,
                      title: d.title,
                      movieId: d.id,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _s(context, 24)),

              Text('Story Line', style: sectionTitle),
              SizedBox(height: _s(context, 8)),
              _StoryLine(text: d.overview),

              if (state.cast.isNotEmpty) ...[
                SizedBox(height: _s(context, 24)),
                Text('Cast and Crew', style: sectionTitle),
                SizedBox(height: _s(context, 15)),

                SizedBox(
                  width: double.infinity,
                  child: ActorsRow(actors: state.cast),
                ),
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

  const _Info({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: _s(context, 13),
          color: AppColors.grey,
        ),
        SizedBox(width: _s(context, 4)),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: _s(context, 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = _s(context, 48);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: AppColors.accent,
          size: _s(context, 22),
        ),
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
    final fontSize = _s(context, 12);

    if (widget.text.isEmpty) {
      return Text(
        'No overview available.',
        style: TextStyle(
          color: AppColors.grey,
          fontSize: fontSize,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : 4,
          overflow: _expanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fontSize,
            height: 1.5,
          ),
        ),
        SizedBox(height: _s(context, 4)),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Less' : 'More',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
