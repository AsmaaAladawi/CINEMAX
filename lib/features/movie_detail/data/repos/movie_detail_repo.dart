import 'package:flutter_application_1/core/networking/api_constants.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';
import 'package:flutter_application_1/features/search/data/actor_model.dart';

import '../models/movie_detail_model.dart';

class MovieDetailRepo {
  final ApiService _api;
  MovieDetailRepo(this._api);

  Future<MovieDetailModel> getDetails(int id) async =>
      MovieDetailModel.fromJson(await _api.get(ApiConstants.movieDetails(id)));

  Future<List<ActorModel>> getCast(int id) async {
    final json = await _api.get(ApiConstants.movieCredits(id));
    return (json['cast'] as List)
        .map((e) => ActorModel.fromJson(e))
        .where((a) => a.profilePath != null)
        .take(12)
        .toList();
  }
}