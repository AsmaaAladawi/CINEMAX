import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/search/data/actor_model.dart';
import '../data/models/movie_detail_model.dart';

sealed class MovieDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class MovieDetailSuccess extends MovieDetailState {
  final MovieDetailModel detail;
  final List<ActorModel> cast;
  MovieDetailSuccess({required this.detail, required this.cast});
  @override
  List<Object?> get props => [detail.id, cast.length];
}