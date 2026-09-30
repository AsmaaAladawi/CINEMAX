import 'package:flutter_application_1/core/networking/api_constants.dart';

import '../../../movie_detail/data/models/movie_detail_model.dart';

class WishlistItem {
  final int id;
  final String title;
  final String? imagePath;
  final double rating;
  final String genre;

  WishlistItem({
    required this.id,
    required this.title,
    this.imagePath,
    required this.rating,
    required this.genre,
  });

  factory WishlistItem.fromDetail(MovieDetailModel d) => WishlistItem(
        id: d.id,
        title: d.title,
        imagePath: d.backdropPath ?? d.posterPath,
        rating: d.voteAverage,
        genre: d.genre,
      );

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json['id'],
        title: json['title'],
        imagePath: json['imagePath'],
        rating: (json['rating'] as num).toDouble(),
        genre: json['genre'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imagePath': imagePath,
        'rating': rating,
        'genre': genre,
      };

  String get imageUrl => '${ApiConstants.imageBase}/w300${imagePath ?? ''}';
}