import 'dart:async';

import 'package:test_task_flutter/features/items/providers/state/items_state.dart';

import '../models/item_model.dart';

abstract interface class IItemsRepository {
  Future<List<ItemModel>> getItems(
    ItemsSort sort,
    String categoryFilter,
    String searchQuery,
  );
  Future<List<String>> getCategories();
  Future<List<ItemModel>> getFavoriteItems();
  Stream<List<ItemModel>> watchFavoriteItems();
  Future<void> toggleFavorite(int itemId);

  void dispose();
}

class ItemsRepository implements IItemsRepository {
  final List<ItemModel> _items = const [
    ItemModel(
      id: 1,
      title: 'Настільна лампа',
      description: 'Компактна атмосферна лампа з регулюванням теплого світла.',
      category: 'Освітлення',
      price: 48.90,
      rating: 4.8,
      colorValue: 0xFF7357A3,
      iconCodePoint: 0xe37c,
    ),
    ItemModel(
      id: 2,
      title: 'Блокнот',
      description: 'Міцний нотатник для ідей, ескізів і планів.',
      category: 'Канцелярія',
      price: 12.50,
      rating: 4.3,
      colorValue: 0xFF557A46,
      iconCodePoint: 0xe0ef,
    ),
    ItemModel(
      id: 3,
      title: 'Портативна колонка',
      description: 'Портативна бездротова колонка в мінімалістичному корпусі.',
      category: 'Електроніка',
      price: 79.00,
      rating: 4.6,
      colorValue: 0xFFB5533C,
      iconCodePoint: 0xe050,
    ),
    ItemModel(
      id: 4,
      title: 'Термопляшка',
      description: 'Термостійка сталева пляшка для щоденного використання.',
      category: 'Аксесуари',
      price: 29.95,
      rating: 4.5,
      colorValue: 0xFF247D81,
      iconCodePoint: 0xe6dd,
    ),
    ItemModel(
      id: 5,
      title: 'Рюкзак',
      description: 'Легкий рюкзак із м’яким відділенням для ноутбука.',
      category: 'Сумки та рюкзаки',
      price: 64.40,
      rating: 4.7,
      colorValue: 0xFF9A6B35,
      iconCodePoint: 0xe2c8,
    ),
  ];

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
    final items = categoryFilter.isEmpty && searchQuery.isEmpty
        ? _items.toList()
        : _items
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
    return _items.map((e) => e.category).toSet().toList();
  }

  @override
  Future<List<ItemModel>> getFavoriteItems() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    return _emitFavoriteItems();
  }

  @override
  Stream<List<ItemModel>> watchFavoriteItems() {
    return Stream.multi((subscriber) {
      final lastFavoriteItems = _lastFavoriteItems;
      if (lastFavoriteItems != null) subscriber.add(lastFavoriteItems);

      final subscription = _favoriteItemsStream.stream.listen(
        subscriber.add,
        onError: subscriber.addError,
        onDone: subscriber.close,
      );
      subscriber.onCancel = subscription.cancel;
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
    _emitFavoriteItems();
  }

  List<ItemModel> _emitFavoriteItems() {
    final lastFavoriteItems = _items
        .where((e) => _favoriteIds.contains(e.id))
        .toList();

    _lastFavoriteItems = lastFavoriteItems;
    if (!_favoriteItemsStream.isClosed) {
      _favoriteItemsStream.add(lastFavoriteItems);
    }
    return lastFavoriteItems;
  }

  @override
  void dispose() {
    _favoriteItemsStream.close();
  }
}
