import 'package:flutter/foundation.dart';

import '../../models/item_model.dart';

enum ItemsSort { original, title, price }

@immutable
class ItemsState {
  const ItemsState({
    required this.items,
    required this.sort,
    required this.isLoading,
    required this.hasLoaded,
    this.errorMessage,
  });

  factory ItemsState.initial() => const ItemsState(
    items: [],
    sort: ItemsSort.original,
    isLoading: false,
    hasLoaded: false,
  );

  final List<ItemModel> items;
  final ItemsSort sort;
  final bool isLoading;
  final bool hasLoaded;
  final String? errorMessage;

  ItemsState copyWith({
    List<ItemModel>? items,
    ItemsSort? sort,
    bool? isLoading,
    bool? hasLoaded,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ItemsState(
      items: items ?? this.items,
      sort: sort ?? this.sort,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
