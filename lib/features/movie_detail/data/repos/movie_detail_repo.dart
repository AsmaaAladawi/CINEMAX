import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/search/data/model/actor_model.dart';

import '../models/movie_detail_model.dart';

class MovieDetailRepo {
  final ApiService _api;
  MovieDetailRepo(this._api);

  Future<MovieDetailModel> getDetails(int id) => _api.getMovieDetails(id);

  Future<List<ActorModel>> getCast(int id) => _api.getMovieCast(id);
}