import 'package:flutter_application_1/core/networking/api_constants.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';

import '../models/genre_model.dart';
import '../../../search/data/movie_model.dart';
import '../models/user_model.dart';

class HomeRepo {
  final ApiService _api;
  HomeRepo(this._api);

  Future<UserModel> getUser() async =>
      UserModel.fromJson(await _api.get(ApiConstants.account));

  Future<List<MovieModel>> getUpcoming() async {
    final json = await _api.get(ApiConstants.upcoming);
    return _movies(json);
  }

  Future<List<GenreModel>> getGenres() async {
    final json = await _api.get(ApiConstants.genres);
    return (json['genres'] as List).map((e) => GenreModel.fromJson(e)).toList();
  }

  Future<List<MovieModel>> getPopular({int genreId = 0}) async {
    final json = genreId == 0
        ? await _api.get(ApiConstants.popular)
        : await _api.get(ApiConstants.discover,
            query: {'with_genres': genreId, 'sort_by': 'popularity.desc'});
    return _movies(json);
  }

  List<MovieModel> _movies(Map<String, dynamic> json) =>
      (json['results'] as List).map((e) => MovieModel.fromJson(e)).toList();
}