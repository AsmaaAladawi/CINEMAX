import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/navigation/option_model.dart';
import 'package:flutter_application_1/features/home/data/models/genre_model.dart';
import 'package:flutter_application_1/features/home/data/models/user_model.dart';
import 'package:flutter_application_1/features/movie_detail/data/models/movie_detail_model.dart';
import 'package:flutter_application_1/features/search/data/model/actor_model.dart';
import 'package:flutter_application_1/features/search/data/model/movie_model.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Authorization': 'Bearer ${ApiConstants.accessToken}',
            'accept': 'application/json',
          },
        ));

  // ───────────────────────── generic helpers ─────────────────────────

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get(endpoint, queryParameters: query);
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get(endpoint, queryParameters: query);
    return response.data as List<dynamic>;
  }

  // ───────────────────────────── account ─────────────────────────────

  Future<UserModel> getUser() async =>
      UserModel.fromJson(await get(ApiConstants.account));

  // ────────────────────────────── movies ─────────────────────────────

  Future<List<MovieModel>> getUpcoming() async =>
      _movies(await get(ApiConstants.upcoming));

  Future<List<MovieModel>> getPopular({int genreId = 0}) async {
    final json = genreId == 0
        ? await get(ApiConstants.popular)
        : await get(ApiConstants.discover,
            query: {'with_genres': genreId, 'sort_by': 'popularity.desc'});
    return _movies(json);
  }

  Future<List<MovieModel>> getTrendingToday() async =>
      _movies(await get(ApiConstants.trendingToday), requirePoster: true);

  Future<List<MovieModel>> getTopRated() async =>
      _movies(await get(ApiConstants.topRated), requirePoster: true);

  Future<List<GenreModel>> getGenres() async {
    final json = await get(ApiConstants.genres);
    return (json['genres'] as List).map((e) => GenreModel.fromJson(e)).toList();
  }

  // ────────────────────────────── search ─────────────────────────────

  Future<List<MovieModel>> searchMovies(String query) async => _movies(
        await get(ApiConstants.searchMovie,
            query: {'query': query, 'include_adult': false}),
        requirePoster: true,
      );

  Future<List<ActorModel>> searchActors(String query) async {
    final json = await get(ApiConstants.searchPerson,
        query: {'query': query, 'include_adult': false});
    return (json['results'] as List)
        .map((e) => ActorModel.fromJson(e))
        .where((a) => a.profilePath != null)
        .take(10)
        .toList();
  }

  // ─────────────────────────── movie details ─────────────────────────

  Future<MovieDetailModel> getMovieDetails(int id) async =>
      MovieDetailModel.fromJson(await get(ApiConstants.movieDetails(id)));

  Future<List<ActorModel>> getMovieCast(int id) async {
    final json = await get(ApiConstants.movieCredits(id));
    return (json['cast'] as List)
        .map((e) => ActorModel.fromJson(e))
        .where((a) => a.profilePath != null)
        .take(12)
        .toList();
  }

  // ───────────────────────── configuration lists ─────────────────────

  Future<List<OptionModel>> getLanguages() async {
    final list = await getList(ApiConstants.languages);
    return list
        .where((e) =>
            e['iso_639_1'] != 'xx' && (e['english_name'] as String).isNotEmpty)
        .map<OptionModel>((e) => OptionModel(
            id: e['iso_639_1'] as String, label: e['english_name'] as String))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  Future<List<OptionModel>> getCountries() async {
    final list = await getList(ApiConstants.countries);
    return list
        .map<OptionModel>((e) => OptionModel(
            id: e['iso_3166_1'] as String, label: e['english_name'] as String))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  // ──────────────────────────── parsing ──────────────────────────────

  List<MovieModel> _movies(
    Map<String, dynamic> json, {
    bool requirePoster = false,
  }) {
    final movies =
        (json['results'] as List).map((e) => MovieModel.fromJson(e));
    return (requirePoster
            ? movies.where((m) => m.posterPath != null)
            : movies)
        .toList();
  }
}