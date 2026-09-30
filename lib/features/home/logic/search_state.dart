import 'package:equatable/equatable.dart';
import '../../home/data/models/genre_model.dart';
import '../../home/data/models/movie_model.dart';
import '../data/models/actor_model.dart';

sealed class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

class SearchInitial extends SearchState {
  final List<MovieModel> today;
  final List<MovieModel> recommended;
  final List<GenreModel> genres;
  SearchInitial({
    required this.today,
    required this.recommended,
    required this.genres,
  });

  @override
  List<Object?> get props =>
      [today.map((m) => m.id).toList(), recommended.map((m) => m.id).toList()];
}

class SearchResults extends SearchState {
  final String query;
  final List<MovieModel> movies;
  final List<ActorModel> actors;
  final List<GenreModel> genres;
  SearchResults({
    required this.query,
    required this.movies,
    required this.actors,
    required this.genres,
  });

  @override
  List<Object?> get props =>
      [query, movies.map((m) => m.id).toList(), actors.map((a) => a.id).toList()];
}