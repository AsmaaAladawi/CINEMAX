import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _repo;
  HomeCubit(this._repo) : super(HomeLoading());

  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      // كل الطلبات بتتنفذ مع بعض
      final user = _repo.getUser();
      final banners = _repo.getUpcoming();
      final genres = _repo.getGenres();
      final popular = _repo.getPopular();
      emit(HomeSuccess(
        user: await user,
        banners: await banners,
        genres: await genres,
        popular: await popular,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> selectGenre(int genreId) async {
    final current = state;
    if (current is! HomeSuccess || current.selectedGenreId == genreId) return;
    emit(current.copyWith(selectedGenreId: genreId, isLoadingMovies: true));
    try {
      final movies = await _repo.getPopular(genreId: genreId);
      emit(current.copyWith(
          selectedGenreId: genreId, popular: movies, isLoadingMovies: false));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}