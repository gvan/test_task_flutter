import 'dart:async';

import 'package:test_task_flutter/features/items/data_source/items_data_source.dart';
import 'package:test_task_flutter/features/items/providers/state/items_state.dart';

import '../models/item_model.dart';

abstract interface class IItemsRepository {
  Future<List<ItemModel>> getItems(
    ItemsSort sort,
    String categoryFilter,
    String searchQuery,
  );
  Future<List<String>> getCategories();
  Stream<List<ItemModel>> watchFavoriteItems();
  Future<void> toggleFavorite(int itemId);

  void dispose();
}

class ItemsRepository implements IItemsRepository {
  ItemsRepository({required this._dataSource});

  final IItemsDataSource _dataSource;
  final Set<int> _favoriteIds = {};
  final _favoriteItemsStream = StreamController<List<ItemModel>>.broadcast();
  List<ItemModel>? _lastFavoriteItems;

  @override
  Future<List<ItemModel>> getItems(
    ItemsSort sort,
    String categoryFilter,
    String searchQuery,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final allItems = await _dataSource.getItems();
    final items = categoryFilter.isEmpty && searchQuery.isEmpty
        ? allItems.toList()
        : allItems
              .where(
                (e) =>
                    (categoryFilter.isNotEmpty &&
                        e.category == categoryFilter) ||
                    (searchQuery.isNotEmpty &&
                        e.title.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        )),
              )
              .toList();

    switch (sort) {
      case ItemsSort.original:
        items.sort((a, b) => a.id.compareTo(b.id));
      case ItemsSort.title:
        items.sort((a, b) => a.title.compareTo(b.title));
      case ItemsSort.price:
        items.sort((a, b) => a.price.compareTo(b.price));
    }
    return items;
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 650));
    return _dataSource.getCategories();
  }

  @override
  Stream<List<ItemModel>> watchFavoriteItems() {
    return Stream.multi((subscriber) async {
      final subscription = _favoriteItemsStream.stream.listen(
        subscriber.add,
        onError: subscriber.addError,
        onDone: subscriber.close,
      );
      subscriber.onCancel = subscription.cancel;

      final lastFavoriteItems = _lastFavoriteItems;
      if (lastFavoriteItems != null) subscriber.add(lastFavoriteItems);

      _loadFavoriteItems().catchError(subscriber.addError);
    });
  }

  @override
  Future<void> toggleFavorite(int itemId) async {
    await Future.delayed(const Duration(milliseconds: 650));
    if (_favoriteIds.contains(itemId)) {
      _favoriteIds.remove(itemId);
    } else {
      _favoriteIds.add(itemId);
    }
    await _emitFavoriteItems();
  }

  Future<void> _loadFavoriteItems() async {
    await Future.delayed(const Duration(milliseconds: 650));
    await _emitFavoriteItems();
  }

  Future<void> _emitFavoriteItems() async {
    final items = await _dataSource.getItems();
    final lastFavoriteItems = items
        .where((e) => _favoriteIds.contains(e.id))
        .toList();

    _lastFavoriteItems = lastFavoriteItems;
    if (!_favoriteItemsStream.isClosed) {
      _favoriteItemsStream.add(lastFavoriteItems);
    }
  }

  @override
  void dispose() {
    _favoriteItemsStream.close();
  }
}
