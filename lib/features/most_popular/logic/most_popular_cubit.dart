import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/data/repos/home_repo.dart';
import 'most_popular_state.dart';

class MostPopularCubit extends Cubit<MostPopularState> {
  final HomeRepo _repo;
  MostPopularCubit(this._repo) : super(MostPopularLoading());

  Future<void> load() async {
    emit(MostPopularLoading());
    try {
      final movies = _repo.getPopular();
      final genres = _repo.getGenres();
      emit(MostPopularSuccess(movies: await movies, genres: await genres));
    } catch (e) {
      emit(MostPopularError(e.toString()));
    }
  }
}