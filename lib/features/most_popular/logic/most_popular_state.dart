import 'package:equatable/equatable.dart';
import '../../home/data/models/genre_model.dart';
import '../../home/data/models/movie_model.dart';

sealed class MostPopularState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MostPopularLoading extends MostPopularState {}

class MostPopularError extends MostPopularState {
  final String message;
  MostPopularError(this.message);
  @override
  List<Object?> get props => [message];
}

class MostPopularSuccess extends MostPopularState {
  final List<MovieModel> movies;
  final List<GenreModel> genres;
  MostPopularSuccess({required this.movies, required this.genres});
  @override
  List<Object?> get props => [movies.map((m) => m.id).toList(), genres.length];
}