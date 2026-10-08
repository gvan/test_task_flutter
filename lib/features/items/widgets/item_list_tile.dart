import 'package:flutter/material.dart';

import '../models/item_model.dart';

class ItemListTile extends StatefulWidget {
  const ItemListTile({super.key, required this.item, required this.onPressed});

  final ItemModel item;
  final ValueChanged<ItemModel> onPressed;

  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile> {
  late final ItemModel _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = Color(item.colorValue);
    return Card(
      child: InkWell(
        onTap: () => widget.onPressed(_selectedItem),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
