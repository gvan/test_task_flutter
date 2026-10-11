import 'dart:async';

import 'package:test_task_flutter/core/provider/base_provider.dart';

import '../repository/items_repository.dart';
import 'state/items_state.dart';

class ItemsProvider extends BaseProvider<ItemsState> {
  ItemsProvider(this._repository);

  final IItemsRepository _repository;
  @override
  ItemsState backedState = ItemsState.initial();
  ItemsState get state => backedState;

  Future<void> loadItems() async {
    if (backedState.isLoading) return;
    setState(backedState.copyWith(isLoading: true, clearError: true));
    try {
      final items = await _repository.getItems(
        state.sort,
        state.categoryFilter,
        state.searchQuery.trim(),
      );
      setState(
        backedState.copyWith(
          items: items,
          isLoading: false,
          hasLoaded: true,
          clearError: true,
        ),
      );
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
}
