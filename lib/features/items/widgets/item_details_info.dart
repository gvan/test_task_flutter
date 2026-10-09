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
        _RatingLabel(item: item),
        const SizedBox(height: 24),
        _PiceBlock(item: item, color: color),
        const SizedBox(height: 20),
        Divider(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
          thickness: 0.5,
        ),
        const SizedBox(height: 12),
        Text(
          'Опис',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
        ),
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

class _RatingLabel extends StatelessWidget {
  const _RatingLabel({required this.item});

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 22, color: Colors.amber.shade700),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: item.rating.toStringAsFixed(1),
                style: TextStyle(fontWeight: .w700),
              ),
              TextSpan(
                children: [
                  TextSpan(
                    text: ' з 5',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _PiceBlock extends StatelessWidget {
  const _PiceBlock({required this.item, required this.color});

  final ItemModel item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '\$${item.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: .w800,
            letterSpacing: -0.5,
          ),
        ),
        Spacer(),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          label: const Text('Зберегти на потім'),
          style: FilledButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(0, 48),
            textStyle: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: .w700),
          ),
        ),
      ],
    );
  }
}
