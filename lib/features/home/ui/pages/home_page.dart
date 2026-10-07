import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/search/ui/page/search_page.dart';
import 'package:flutter_application_1/features/most_popular/pages/most_popular_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/bottom_nav_handler.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../wishlist/ui/pages/wishlist_page.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../widgets/categories_list.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/movie_banner_carousel.dart';
import '../widgets/popular_movies_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (i) => handleBottomNav(context, current: 0, index: i),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => switch (state) {
            HomeLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.accent)),
            HomeError(:final message) => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().loadHome(),
                    child: const Text('Retry'),
                  ),
                ]),
              ),
            HomeSuccess() => _Content(state: state),
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final HomeSuccess state;
  const _Content({required this.state});

  @override
  Widget build(BuildContext context) {
    const title = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: HomeHeader(
            user: state.user,
            onFavoriteTap: () => Navigator.push(context, WishlistPage.route()),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: HomeSearchBar(
            onTap: () => Navigator.push(context, SearchPage.route()),
          ),
        ),
        const SizedBox(height: 24),
        MovieBannerCarousel(movies: state.banners),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Categories', style: title),
        ),
        const SizedBox(height: 12),
        CategoriesList(
          genres: state.genres,
          selectedId: state.selectedGenreId,
          onSelected: context.read<HomeCubit>().selectGenre,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Most popular', style: title),
              GestureDetector(
                onTap: () => Navigator.push(context, MostPopularPage.route()),
                child: const Text('See All',
                    style: TextStyle(
                        color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        state.isLoadingMovies
            ? const SizedBox(
                height: 210,
                child: Center(child: CircularProgressIndicator(color: AppColors.accent)))
            : PopularMoviesList(movies: state.popular, genres: state.genres),
      ],
    );
  }
}