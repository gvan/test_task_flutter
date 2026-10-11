import 'dart:async';

import 'package:test_task_flutter/core/provider/base_provider.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/providers/state/item_details_state.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

class ItemDetailsProvider extends BaseProvider<ItemDetailsState> {
  ItemDetailsProvider(this._repository, ItemModel item)
    : backedState = .initial(item = item);

  final IItemsRepository _repository;
  @override
  ItemDetailsState backedState;
  ItemDetailsState get state => backedState;
  StreamSubscription? _favoriteItemsSubscription;

  void watchFavoriteItems() {
    _favoriteItemsSubscription = _repository.watchFavoriteItems().listen((
      favoriteItems,
    ) {
      setState(backedState.copyWith(favoriteItems: favoriteItems));
    });
  }

  void loadFavoriteItems() {
    _repository.getFavoriteItems();
  }

  Future<void> toggleFavorite() async {
    if (backedState.isFavoriteLoading) return;
    setState(backedState.copyWith(isFavoriteLoading: true));
    await _repository.toggleFavorite(state.item.id);
    setState(backedState.copyWith(isFavoriteLoading: false));
  }

  @override
  void dispose() {
    _favoriteItemsSubscription?.cancel();
    super.dispose();
  }
}
