import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/search/data/Searchrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/navigation/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../home/data/models/genre_model.dart';
import '../data/movie_model.dart';
import '../../home/ui/widgets/popular_movies_list.dart';
import '../logic/search_cubit.dart';
import '../logic/search_state.dart';
import '../../home/ui/widgets/actors_row.dart';
import 'empty_search_view.dart';
import 'search_field.dart';
import 'search_movie_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => SearchCubit(SearchRepo(ApiService()))..loadInitial(),
          child: const SearchPage(),
        ),
      );

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancel(BuildContext context) {
    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (i) => handleBottomNav(context, current: 1, index: i),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: SearchField(
                controller: _controller,
                onChanged: context.read<SearchCubit>().onQueryChanged,
                onCancel: () => _cancel(context),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) => switch (state) {
                  SearchLoading() => const Center(
                      child: CircularProgressIndicator(color: AppColors.accent)),
                  SearchEmpty() => const EmptySearchView(),
                  SearchError(:final message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  SearchInitial() => _InitialView(state: state),
                  SearchResults() => _ResultsView(state: state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 

String _genreName(MovieModel m, List<GenreModel> genres) {
  if (m.genreIds.isEmpty) return '';
  return genres
      .firstWhere((g) => g.id == m.genreIds.first,
          orElse: () => GenreModel(id: 0, name: ''))
      .name;
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final bool seeAll;
  const _SectionTitle(this.text, {this.seeAll = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          if (seeAll)
            const Text('See All',
                style: TextStyle(
                    color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  final SearchInitial state;
  const _InitialView({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        if (state.today.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Today'),
                SearchMovieItem(
                  movie: state.today.first,
                  genre: _genreName(state.today.first, state.genres),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _SectionTitle('Recommend for you', seeAll: true),
        ),
        PopularMoviesList(movies: state.recommended, genres: state.genres),
      ],
    );
  }
}

class _ResultsView extends StatelessWidget {
  final SearchResults state;
  const _ResultsView({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasActors = state.actors.isNotEmpty;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      children: [
        if (hasActors) ...[
          const _SectionTitle('Actors'),
          ActorsRow(actors: state.actors),
          const SizedBox(height: 24),
        ],
        if (state.movies.isNotEmpty) ...[
          if (hasActors) const _SectionTitle('Movie Related', seeAll: true),
          for (final m in state.movies)
            SearchMovieItem(movie: m, genre: _genreName(m, state.genres)),
        ],
      ],
    );
  }
}