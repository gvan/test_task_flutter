import 'package:flutter/foundation.dart';

import '../models/item_model.dart';
import '../repository/items_repository.dart';
import 'state/items_state.dart';

class ItemsProvider extends ChangeNotifier {
  ItemsProvider(this._repository);

  final IItemsRepository _repository;
  ItemsState _state = ItemsState.initial();
  ItemsState get state => _state;

  Future<void> loadItems() async {
    if (_state.isLoading) return;
    _setState(_state.copyWith(isLoading: true, clearError: true));
    try {
      final items = await _repository.getItems();
      _setState(
        _state.copyWith(
          items: items,
          isLoading: false,
          hasLoaded: true,
          clearError: true,
        ),
      );
    } catch (error) {
      _setState(
        _state.copyWith(
          isLoading: false,
          hasLoaded: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void sortBy(ItemsSort sort) {
    final items = List<ItemModel>.of(_state.items);
    switch (sort) {
      case ItemsSort.original:
        items.sort((a, b) => a.id.compareTo(b.id));
      case ItemsSort.title:
        items.sort((a, b) => a.title.compareTo(b.title));
      case ItemsSort.price:
        items.sort((a, b) => a.price.compareTo(b.price));
    }
    _setState(_state.copyWith(items: items, sort: sort));
  }

  void _setState(ItemsState state) {
    _state = state;
    notifyListeners();
  }
}
