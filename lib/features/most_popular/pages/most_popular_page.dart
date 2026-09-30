import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/home/data/models/genre_model.dart';
import 'package:flutter_application_1/features/home/data/models/movie_model.dart';
import 'package:flutter_application_1/features/home/data/repos/home_repo.dart';
import 'package:flutter_application_1/features/home/ui/widgets/search_movie_item.dart';
import 'package:flutter_application_1/features/most_popular/logic/most_popular_cubit.dart';
import 'package:flutter_application_1/features/most_popular/logic/most_popular_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/page_header.dart';


class MostPopularPage extends StatelessWidget {
  const MostPopularPage({super.key});

  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => MostPopularCubit(HomeRepo(ApiService()))..load(),
          child: const MostPopularPage(),
        ),
      );

  String _genreName(MovieModel m, List<GenreModel> genres) {
    if (m.genreIds.isEmpty) return '';
    return genres
        .firstWhere((g) => g.id == m.genreIds.first,
            orElse: () => GenreModel(id: 0, name: ''))
        .name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Most Popular Movie'),
            Expanded(
              child: BlocBuilder<MostPopularCubit, MostPopularState>(
                builder: (context, state) => switch (state) {
                  MostPopularLoading() => const Center(
                      child: CircularProgressIndicator(color: AppColors.accent)),
                  MostPopularError(:final message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  MostPopularSuccess() => Builder(builder: (_) {
                      final movies =
                          state.movies.where((m) => m.posterPath != null).toList();
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        itemCount: movies.length,
                        itemBuilder: (_, i) => SearchMovieItem(
                          movie: movies[i],
                          genre: _genreName(movies[i], state.genres),
                        ),
                      );
                    }),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}