import 'package:flutter_application_1/core/networking/api_constants.dart';


class MovieModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'],
        title: json['title'] ?? '',
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
        releaseDate: json['release_date'] ?? '',
        genreIds: List<int>.from(json['genre_ids'] ?? []),
      );

  String get posterUrl => '${ApiConstants.imageBase}/w500$posterPath';
  String get backdropUrl => '${ApiConstants.imageBase}/w780${backdropPath ?? posterPath}';

  String get formattedDate {
    final p = releaseDate.split('-');
    if (p.length != 3) return '';
    const m = ['January','February','March','April','May','June','July',
      'August','September','October','November','December'];
    return 'On ${m[int.parse(p[1]) - 1]} ${int.parse(p[2])}, ${p[0]}';
  }
}