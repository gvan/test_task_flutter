import 'dart:async';

import 'package:test_task_flutter/core/provider/base_provider.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

import '../repository/items_repository.dart';
import 'state/items_state.dart';

class ItemsProvider extends BaseProvider<ItemsState> {
  ItemsProvider(this._repository);

  final IItemsRepository _repository;
  @override
  ItemsState backedState = ItemsState.initial();
  ItemsState get state => backedState;
  StreamSubscription<List<ItemModel>>? _loadSubscription;
  Completer<void>? _loadCompleter;

  Future<void> loadItems() {
    _cancelLoad();
    setState(backedState.copyWith(isLoading: true, clearError: true));

    final completer = Completer<void>();
    _loadCompleter = completer;
    _loadSubscription = _repository
        .getItems(state.sort, state.categoryFilter, state.searchQuery.trim())
        .asStream()
        .listen(
          (items) {
            setState(
              backedState.copyWith(
                items: items,
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
            completer.complete();
          },
          onDone: completer.complete,
          cancelOnError: true,
        );
    return completer.future;
  }

  @override
  void dispose() {
    _cancelLoad();
    super.dispose();
  }

  Future<void> loadCategories() async {
    try {
      final categories = await _repository.getCategories();
      setState(backedState.copyWith(categories: categories));
    } catch (_) {}
  }

  void sortBy(ItemsSort sort) {
    setState(backedState.copyWith(sort: sort));
    loadItems();
  }

  void filterByCategory(String category) {
    setState(backedState.copyWith(categoryFilter: category));
    loadItems();
  }

  void search(String query) {
    setState(backedState.copyWith(searchQuery: query));
    loadItems();
  }

  void clearParameters() {
    setState(
      backedState.copyWith(
        sort: .original,
        categoryFilter: '',
        searchQuery: '',
      ),
    );
    loadItems();
  }

  void _cancelLoad() {
    _loadSubscription?.cancel();
    _loadSubscription = null;
    final completer = _loadCompleter;
    if (completer != null && !completer.isCompleted) completer.complete();
    _loadCompleter = null;
  }
}
