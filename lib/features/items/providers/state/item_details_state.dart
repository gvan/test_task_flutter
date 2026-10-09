import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

@immutable
class ItemDetailsState {
  const ItemDetailsState({required this.item});

  factory ItemDetailsState.initial(ItemModel item) =>
      ItemDetailsState(item: item);

  final ItemModel item;

  ItemDetailsState copyWith({ItemModel? item}) {
    return ItemDetailsState(item: item ?? this.item);
  }
}
