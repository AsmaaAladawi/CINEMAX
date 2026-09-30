import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/wishlist_item.dart';
import '../data/repos/wishlist_repo.dart';

class WishlistCubit extends Cubit<List<WishlistItem>> {
  static final WishlistCubit instance = WishlistCubit._(WishlistRepo());

  final WishlistRepo _repo;
  WishlistCubit._(this._repo) : super(const []) {
    load();
  }

  Future<void> load() async => emit(await _repo.load());

  Future<void> toggle(WishlistItem item) async {
    final list = List<WishlistItem>.from(state);
    final i = list.indexWhere((e) => e.id == item.id);
    i == -1 ? list.insert(0, item) : list.removeAt(i);
    emit(list);
    await _repo.save(list);
  }

  Future<void> remove(int id) async {
    final list = state.where((e) => e.id != id).toList();
    emit(list);
    await _repo.save(list);
  }
}