import 'package:equatable/equatable.dart';
import '../data/models/genre_model.dart';
import '../data/models/movie_model.dart';
import '../data/models/user_model.dart';

sealed class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

class HomeSuccess extends HomeState {
  final UserModel user;
  final List<MovieModel> banners;
  final List<GenreModel> genres;
  final List<MovieModel> popular;
  final int selectedGenreId; // 0 = All
  final bool isLoadingMovies;

  HomeSuccess({
    required this.user,
    required this.banners,
    required this.genres,
    required this.popular,
    this.selectedGenreId = 0,
    this.isLoadingMovies = false,
  });

  HomeSuccess copyWith({
    List<MovieModel>? popular,
    int? selectedGenreId,
    bool? isLoadingMovies,
  }) =>
      HomeSuccess(
        user: user,
        banners: banners,
        genres: genres,
        popular: popular ?? this.popular,
        selectedGenreId: selectedGenreId ?? this.selectedGenreId,
        isLoadingMovies: isLoadingMovies ?? this.isLoadingMovies,
      );

  @override
  List<Object?> get props => [
        user.id,
        banners.length,
        genres.length,
        popular.map((m) => m.id).toList(),
        selectedGenreId,
        isLoadingMovies,
      ];
}