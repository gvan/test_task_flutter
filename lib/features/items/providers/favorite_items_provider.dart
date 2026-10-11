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

  void watchFavoriteItems() async {
    _itemsSubscription?.cancel();
    _itemsSubscription = _repository.watchFavoriteItems().listen(
      (favoriteItems) {
        setState(
          backedState.copyWith(
            favoriteItems: favoriteItems,
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

    setState(backedState.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.getFavoriteItems();
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
