import 'package:flutter_application_1/core/networking/api_service.dart';

import '../models/genre_model.dart';
import '../../../search/data/model/movie_model.dart';
import '../models/user_model.dart';

class HomeRepo {
  final ApiService _api;
  HomeRepo(this._api);

  Future<UserModel> getUser() => _api.getUser();

  Future<List<MovieModel>> getUpcoming() => _api.getUpcoming();

  Future<List<GenreModel>> getGenres() => _api.getGenres();

  Future<List<MovieModel>> getPopular({int genreId = 0}) =>
      _api.getPopular(genreId: genreId);
}