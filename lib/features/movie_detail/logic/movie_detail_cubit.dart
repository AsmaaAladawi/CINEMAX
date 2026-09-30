import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/movie_detail_repo.dart';
import 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieDetailRepo _repo;
  MovieDetailCubit(this._repo) : super(MovieDetailLoading());

  Future<void> load(int id) async {
    emit(MovieDetailLoading());
    try {
      final detail = _repo.getDetails(id);
      final cast = _repo.getCast(id);
      emit(MovieDetailSuccess(detail: await detail, cast: await cast));
    } catch (e) {
      emit(MovieDetailError(e.toString()));
    }
  }
}