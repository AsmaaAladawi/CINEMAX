import 'package:flutter_application_1/core/networking/api_constants.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';

import '../../../home/data/models/genre_model.dart';
import '../model/movie_model.dart';
import '../model/actor_model.dart';

class SearchRepo {
  final ApiService _api;
  SearchRepo(this._api);

  Future<List<MovieModel>> getTrendingToday() async =>
      _movies(await _api.get(ApiConstants.trendingToday));

  Future<List<MovieModel>> getRecommended() async =>
      _movies(await _api.get(ApiConstants.topRated));

  Future<List<GenreModel>> getGenres() async {
    final json = await _api.get(ApiConstants.genres);
    return (json['genres'] as List).map((e) => GenreModel.fromJson(e)).toList();
  }

  Future<List<MovieModel>> searchMovies(String query) async => _movies(
        await _api.get(ApiConstants.searchMovie,
            query: {'query': query, 'include_adult': false}),
      );

  Future<List<ActorModel>> searchActors(String query) async {
    final json = await _api.get(ApiConstants.searchPerson,
        query: {'query': query, 'include_adult': false});
    return (json['results'] as List)
        .map((e) => ActorModel.fromJson(e))
        .where((a) => a.profilePath != null)
        .take(10)
        .toList();
  }

  List<MovieModel> _movies(Map<String, dynamic> json) => (json['results'] as List)
      .map((e) => MovieModel.fromJson(e))
      .where((m) => m.posterPath != null)
      .toList();
}