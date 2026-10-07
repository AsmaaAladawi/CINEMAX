import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/wishlist_item.dart';
import '../data/repos/wishlist_repo.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo _repo;
  WishlistCubit(this._repo) : super(const WishlistState());

  Future<void> load() async {
    final items = await _repo.load();
    emit(WishlistState(items: items, isLoading: false));
  }

  Future<void> toggle(WishlistItem item) async {
    final list = List<WishlistItem>.from(state.items);
    final i = list.indexWhere((e) => e.id == item.id);
    i == -1 ? list.insert(0, item) : list.removeAt(i);
    emit(state.copyWith(items: list));
    await _repo.save(list);
  }

  Future<void> remove(int id) async {
    final list = state.items.where((e) => e.id != id).toList();
    emit(state.copyWith(items: list));
    await _repo.save(list);
  }
}