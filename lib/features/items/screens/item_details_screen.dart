import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../widgets/item_animation_preview.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.item});

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Деталі товару')),
      body: _ItemDetailsBody(item: item),
    );
  }
}

class _ItemDetailsBody extends StatelessWidget {
  const _ItemDetailsBody({required this.item});

  static const _wideWidth = 720.0;
  static const _maxContentWidth = 1040.0;

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.colorValue);
    final icon = IconData(item.iconCodePoint, fontFamily: 'MaterialIcons');
    final isWide = MediaQuery.sizeOf(context).width >= _wideWidth;
    final preview = ItemAnimationPreview(color: color, icon: icon);
    final details = _ItemDetails(item: item);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxContentWidth),
        child: isWide
            ? Row(
                children: [
                  Expanded(child: preview),
                  SizedBox(width: 24),
                  Expanded(child: details),
                ],
              )
            : Column(children: [preview, const SizedBox(height: 24), details]),
      ),
    );
  }
}

class _ItemDetails extends StatelessWidget {
  const _ItemDetails({required this.item});

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Chip(label: Text(item.category)),
          ],
        ),

        const SizedBox(height: 12),
        Text(item.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        Card.filled(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.star_rounded),
                const SizedBox(width: 8),
                Text('Рейтинг: ${item.rating}'),
                const Spacer(),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          label: const Text('Зберегти на потім'),
        ),
      ],
    );
  }
}
