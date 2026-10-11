import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

@immutable
class ItemDetailsState {
  const ItemDetailsState({
    required this.item,
    required this.isFavoriteLoading,
    required this.favoriteItems,
  });

  factory ItemDetailsState.initial(ItemModel item) =>
      ItemDetailsState(item: item, isFavoriteLoading: false, favoriteItems: []);

  final ItemModel item;
  final bool isFavoriteLoading;
  final List<ItemModel> favoriteItems;

  ItemDetailsState copyWith({
    ItemModel? item,
    bool? isFavoriteLoading,
    List<ItemModel>? favoriteItems,
  }) {
    return ItemDetailsState(
      item: item ?? this.item,
      isFavoriteLoading: isFavoriteLoading ?? this.isFavoriteLoading,
      favoriteItems: favoriteItems ?? this.favoriteItems,
    );
  }
}
