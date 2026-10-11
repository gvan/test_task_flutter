import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/widgets/item_list_tile.dart';

extension ListItemModelX on List<ItemModel> {
  List<int> toIds() => map((e) => e.id).toList();
}

extension WidgetTesterX on WidgetTester {
  List<int> toItemListIds() => widgetList<ItemListTile>(
    find.byType(ItemListTile),
  ).map((tile) => tile.item.id).toList();
}
