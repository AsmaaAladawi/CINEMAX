import 'package:flutter_application_1/core/networking/api_constants.dart';


class MovieDetailModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final int runtime;
  final String releaseDate;
  final double voteAverage;
  final List<String> genres;

  MovieDetailModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.runtime,
    required this.releaseDate,
    required this.voteAverage,
    required this.genres,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) => MovieDetailModel(
        id: json['id'],
        title: json['title'] ?? '',
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        overview: json['overview'] ?? '',
        runtime: json['runtime'] ?? 0,
        releaseDate: json['release_date'] ?? '',
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
        genres: (json['genres'] as List? ?? []).map((g) => g['name'] as String).toList(),
      );

  String get posterUrl => '${ApiConstants.imageBase}/w500${posterPath ?? ''}';
  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '-';
  String get duration => runtime > 0 ? '$runtime Minutes' : '-';
  String get genre => genres.isEmpty ? '-' : genres.first;
}