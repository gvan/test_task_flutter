import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/providers/state/items_state.dart';

class SortAction extends StatelessWidget {
  const SortAction({
    super.key,
    required this.initialValue,
    required this.onSelected,
  });

  final ItemsSort initialValue;
  final Function(ItemsSort) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ItemsSort>(
      initialValue: initialValue,
      onSelected: onSelected,
      icon: const Icon(Icons.sort),
      tooltip: 'Сортувати товари',
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: ItemsSort.original,
          child: Text('Початковий порядок'),
        ),
        PopupMenuItem(value: ItemsSort.title, child: Text('Назва')),
        PopupMenuItem(value: ItemsSort.price, child: Text('Ціна')),
      ],
    );
  }
}
