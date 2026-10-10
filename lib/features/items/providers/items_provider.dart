import 'dart:async';

import 'package:test_task_flutter/core/provider/base_provider.dart';

import '../models/item_model.dart';
import '../repository/items_repository.dart';
import 'state/items_state.dart';

class ItemsProvider extends BaseProvider<ItemsState> {
  ItemsProvider(this._repository);

  final IItemsRepository _repository;
  @override
  ItemsState backedState = ItemsState.initial();
  ItemsState get state => backedState;

  Future<void> loadItems() async {
    if (backedState.isLoading) return;
    setState(backedState.copyWith(isLoading: true, clearError: true));
    try {
      final items = await _repository.getItems();
      setState(
        backedState.copyWith(
          items: items,
          isLoading: false,
          hasLoaded: true,
          clearError: true,
        ),
      );
    } catch (error) {
      setState(
        backedState.copyWith(
          isLoading: false,
          hasLoaded: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void sortBy(ItemsSort sort) {
    final items = List<ItemModel>.of(backedState.items);
    switch (sort) {
      case ItemsSort.original:
        items.sort((a, b) => a.id.compareTo(b.id));
      case ItemsSort.title:
        items.sort((a, b) => a.title.compareTo(b.title));
      case ItemsSort.price:
        items.sort((a, b) => a.price.compareTo(b.price));
    }
    setState(backedState.copyWith(items: items, sort: sort));
  }
  
}
