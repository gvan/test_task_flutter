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

  Future<void> toggleFavorite() async {
    final item = await _repository.toggleFavorite(state.item.id);
    setState(backedState.copyWith(item: item));
  }
}
