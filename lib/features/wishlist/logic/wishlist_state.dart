import 'package:equatable/equatable.dart';
import '../data/models/wishlist_item.dart';

class WishlistState extends Equatable {
  final List<WishlistItem> items;
  final bool isLoading;

  const WishlistState({this.items = const [], this.isLoading = true});

  bool contains(int id) => items.any((e) => e.id == id);

  WishlistState copyWith({List<WishlistItem>? items, bool? isLoading}) =>
      WishlistState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [items.map((e) => e.id).toList(), isLoading];
}