import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/providers/item_details_provider.dart';
import 'package:test_task_flutter/features/items/widgets/item_details_info.dart';

import '../widgets/item_animation_preview.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Деталі товару')),
      body: _ItemDetailsBody(),
    );
  }
}

class _ItemDetailsBody extends StatelessWidget {
  const _ItemDetailsBody();

  static const _wideWidth = 720.0;
  static const _maxContentWidth = 1040.0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemDetailsProvider>();
    final item = provider.state.item;

    final color = Color(item.colorValue);
    final icon = IconData(item.iconCodePoint, fontFamily: 'MaterialIcons');
    final isWide = MediaQuery.sizeOf(context).width >= _wideWidth;

    final preview = ItemAnimationPreview(color: color, icon: icon);
    final details = ItemDetailsInfo(
      item: item,
      color: color,
      onFavoriteTap: () => provider.toggleFavorite(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxContentWidth),
        child: isWide
            ? Row(
                crossAxisAlignment: .start,
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
