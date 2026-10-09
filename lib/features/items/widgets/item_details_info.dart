import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

class ItemDetailsInfo extends StatelessWidget {
  const ItemDetailsInfo({super.key, required this.item, required this.color});

  final ItemModel item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        _CategoryLabel(item: item, color: color),
        const SizedBox(height: 12),
        Text(
          item.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: .w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star_rounded),
            const SizedBox(width: 8),
            Text('${item.rating} з 5'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
              label: const Text('Зберегти на потім'),
              style: FilledButton.styleFrom(backgroundColor: color),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(),
        const SizedBox(height: 12),
        Text('Опис', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        Text(item.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.item, required this.color});

  final ItemModel item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Padding(
        padding: const .all(4),
        child: Row(
          children: [
            Icon(Icons.sell_outlined, size: 14, color: color),
            SizedBox(width: 4),
            Text(
              item.category,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.12),
    );
  }
}
