import 'package:test_task_flutter/features/items/models/item_model.dart';

extension ListItemModelX on List<ItemModel> {
  List<int> toIds() => map((e) => e.id).toList();
}
