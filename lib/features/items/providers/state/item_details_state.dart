import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

@immutable
class ItemDetailsState {
  const ItemDetailsState({required this.item, required this.favoriteItems});

  factory ItemDetailsState.initial(ItemModel item) =>
      ItemDetailsState(item: item, favoriteItems: []);

  final ItemModel item;
  final List<ItemModel> favoriteItems;

  ItemDetailsState copyWith({ItemModel? item, List<ItemModel>? favoriteItems}) {
    return ItemDetailsState(
      item: item ?? this.item,
      favoriteItems: favoriteItems ?? this.favoriteItems,
    );
  }
}
