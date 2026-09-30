import 'dart:async';
import 'package:flutter_application_1/features/home/data/repos/Searchrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/data/models/genre_model.dart';
import '../../home/data/models/movie_model.dart';
import '../data/models/actor_model.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _repo;
  SearchCubit(this._repo) : super(SearchLoading());

  Timer? _debounce;
  SearchInitial? _initial;
  List<GenreModel> _genres = [];
  String _lastQuery = '';

  Future<void> loadInitial() async {
    emit(SearchLoading());
    try {
      final today = _repo.getTrendingToday();
      final recommended = _repo.getRecommended();
      final genres = _repo.getGenres();
      _genres = await genres;
      _initial = SearchInitial(
        today: await today,
        recommended: await recommended,
        genres: _genres,
      );
      emit(_initial!);
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    _lastQuery = query;

    if (query.isEmpty) {
      final initial = _initial;
      initial != null ? emit(initial) : loadInitial();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(query));
  }

  Future<void> _search(String query) async {
    emit(SearchLoading());
    try {
      final res = await Future.wait<Object>([
        _repo.searchMovies(query),
        _repo.searchActors(query),
      ]);
      if (query != _lastQuery) return; 
      final movies = res[0] as List<MovieModel>;
      final actors = res[1] as List<ActorModel>;

      if (movies.isEmpty && actors.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchResults(
            query: query, movies: movies, actors: actors, genres: _genres));
      }
    } catch (e) {
      if (query == _lastQuery) emit(SearchError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}