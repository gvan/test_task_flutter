import 'dart:async';

import 'package:test_task_flutter/core/provider/base_provider.dart';
import 'package:test_task_flutter/features/items/providers/state/favorite_items_state.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

class FavoriteItemsProvider extends BaseProvider<FavoriteItemsState> {
  FavoriteItemsProvider({required this._repository});

  final IItemsRepository _repository;
  @override
  FavoriteItemsState backedState = FavoriteItemsState.initial();
  FavoriteItemsState get state => backedState;
  StreamSubscription? _itemsSubscription;

  void watchItems() {
    _itemsSubscription = _repository.watchItems().listen(
      (items) {
        setState(
          backedState.copyWith(
            favoriteItems: items.where((e) => e.favorite).toList(),
            isLoading: false,
            hasLoaded: true,
            clearError: true,
          ),
        );
      },
      onError: (Object error) {
        setState(
          backedState.copyWith(
            isLoading: false,
            hasLoaded: true,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> loadItems() async {
    if (backedState.isLoading) return;
    setState(backedState.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.getItems();
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

  @override
  void dispose() {
    _itemsSubscription?.cancel();
    super.dispose();
  }
}
