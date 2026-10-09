import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

@immutable
class FavoriteItemsState {
  const FavoriteItemsState({
    required this.favoriteItems,
    required this.isLoading,
    required this.hasLoaded,
    this.errorMessage,
  });

  factory FavoriteItemsState.initial() => const FavoriteItemsState(
    favoriteItems: [],
    isLoading: false,
    hasLoaded: false,
  );

  final List<ItemModel> favoriteItems;
  final bool isLoading;
  final bool hasLoaded;
  final String? errorMessage;

  FavoriteItemsState copyWith({
    List<ItemModel>? favoriteItems,
    bool? isLoading,
    bool? hasLoaded,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoriteItemsState(
      favoriteItems: favoriteItems ?? this.favoriteItems,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
