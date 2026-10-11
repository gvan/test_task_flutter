import 'package:flutter/material.dart';

enum ItemsType { all, parameters, favorite }

class ItemsEmptyView extends StatelessWidget {
  const ItemsEmptyView({super.key, required this._itemsType});

  factory ItemsEmptyView.all() => ItemsEmptyView(itemsType: .all);

  factory ItemsEmptyView.parameters() => ItemsEmptyView(itemsType: .parameters);

  factory ItemsEmptyView.favorite() => ItemsEmptyView(itemsType: .favorite);

  final ItemsType _itemsType;

  @override
  Widget build(BuildContext context) {
    final title = switch (_itemsType) {
      .all => 'Товарів поки немає',
      .parameters => 'Немає товарів\nза заданими параметрами',
      .favorite => 'Немає збережених товарів',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 48),
          const SizedBox(height: 12),
          Text(title, textAlign: .center),
        ],
      ),
    );
  }
}
