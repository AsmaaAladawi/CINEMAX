import 'package:flutter/material.dart';
import '../../data/models/genre_model.dart';
import '../../../search/data/movie_model.dart';
import 'movie_card.dart';

class PopularMoviesList extends StatelessWidget {
  final List<MovieModel> movies;
  final List<GenreModel> genres;
  const PopularMoviesList({super.key, required this.movies, required this.genres});

  String _genreName(MovieModel m) {
    if (m.genreIds.isEmpty) return '';
    return genres
        .firstWhere((g) => g.id == m.genreIds.first,
            orElse: () => GenreModel(id: 0, name: ''))
        .name;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => MovieCard(movie: movies[i], genre: _genreName(movies[i])),
      ),
    );
  }
}