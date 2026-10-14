import 'package:flutter_application_1/core/networking/api_service.dart';

import '../../../home/data/models/genre_model.dart';
import '../model/movie_model.dart';
import '../model/actor_model.dart';

class SearchRepo {
  final ApiService _api;
  SearchRepo(this._api);

  Future<List<MovieModel>> getTrendingToday() => _api.getTrendingToday();

  Future<List<MovieModel>> getRecommended() => _api.getTopRated();

  Future<List<GenreModel>> getGenres() => _api.getGenres();

  Future<List<MovieModel>> searchMovies(String query) =>
      _api.searchMovies(query);

  Future<List<ActorModel>> searchActors(String query) =>
      _api.searchActors(query);
}