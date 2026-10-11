import 'package:flutter/foundation.dart';

import '../../models/item_model.dart';

enum ItemsSort { original, title, price }

@immutable
class ItemsState {
  const ItemsState({
    required this.items,
    required this.categories,
    required this.sort,
    required this.categoryFilter,
    required this.searchQuery,
    required this.isLoading,
    required this.hasLoaded,
    this.errorMessage,
  });

  factory ItemsState.initial() => const ItemsState(
    items: [],
    categories: [],
    sort: ItemsSort.original,
    categoryFilter: '',
    searchQuery: '',
    isLoading: false,
    hasLoaded: false,
  );

  final List<ItemModel> items;
  final List<String> categories;
  final ItemsSort sort;
  final String categoryFilter;
  final String searchQuery;
  final bool isLoading;
  final bool hasLoaded;
  final String? errorMessage;

  ItemsState copyWith({
    List<ItemModel>? items,
    List<String>? categories,
    ItemsSort? sort,
    String? categoryFilter,
    String? searchQuery,
    bool? isLoading,
    bool? hasLoaded,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ItemsState(
      items: items ?? this.items,
      categories: categories ?? this.categories,
      sort: sort ?? this.sort,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
