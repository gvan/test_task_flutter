import 'package:flutter/material.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

class ItemDetailsInfo extends StatelessWidget {
  const ItemDetailsInfo({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.isFavoriteLoading,
    required this.color,
    required this.onFavoriteTap,
  });

  final ItemModel item;
  final bool isFavorite;
  final bool isFavoriteLoading;
  final Color color;
  final Function() onFavoriteTap;

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
        _PriceBlock(
          item: item,
          isFavorite: isFavorite,
          isFavoriteLoading: isFavoriteLoading,
          color: color,
          onFavoriteTap: onFavoriteTap,
        ),
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
          mainAxisSize: .min,
          children: [
            Icon(Icons.sell_outlined, size: 14, color: color),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                item.category,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: color),
              ),
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

  static const _maxRating = 5;

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: .min,
          children: [
            for (var i = 0; i < _maxRating; i++)
              RatingStar(rating: (item.rating - i).clamp(0, 1).toDouble()),
          ],
        ),
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
                    text: ' з $_maxRating',
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

class RatingStar extends StatelessWidget {
  const RatingStar({super.key, required this.rating})
    : assert(rating >= 0 && rating <= 1);

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          Icons.star_rounded,
          size: 22,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        ClipRect(
          child: Align(
            alignment: .centerStart,
            widthFactor: rating,
            heightFactor: 1,
            child: Icon(
              Icons.star_rounded,
              size: 22,
              color: Colors.amber.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({
    required this.item,
    required this.isFavorite,
    required this.isFavoriteLoading,
    required this.color,
    required this.onFavoriteTap,
  });

  final ItemModel item;
  final bool isFavorite;
  final bool isFavoriteLoading;
  final Color color;
  final Function() onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: .w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onFavoriteTap,
          icon: isFavoriteLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          label: Text(isFavorite ? 'Збережено' : 'Зберегти на потім'),
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
