import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/providers/item_details_provider.dart';
import 'package:test_task_flutter/features/items/providers/state/item_details_state.dart';
import 'package:test_task_flutter/features/items/widgets/item_details_info.dart';

import '../widgets/item_animation_preview.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key});

  static const _wideWidth = 720.0;
  static const _maxContentWidth = 1040.0;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<ItemDetailsProvider>();
    provider.watchFavoriteItems();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemDetailsProvider>();
    final state = provider.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Деталі товару')),
      body: SafeArea(child: _buildBody(state, provider)),
    );
  }

  SingleChildScrollView _buildBody(
    ItemDetailsState state,
    ItemDetailsProvider provider,
  ) {
    final item = state.item;
    final favoriteItems = state.favoriteItems;

    final color = Color(item.colorValue);
    final icon = IconData(item.iconCodePoint, fontFamily: 'MaterialIcons');
    final isWide =
        MediaQuery.sizeOf(context).width >= ItemDetailsScreen._wideWidth;

    final preview = ItemAnimationPreview(color: color, icon: icon);
    final details = ItemDetailsInfo(
      item: item,
      isFavorite: favoriteItems.any((e) => e.id == item.id),
      isFavoriteLoading: state.isFavoriteLoading,
      color: color,
      onFavoriteTap: () => provider.toggleFavorite(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ItemDetailsScreen._maxContentWidth,
        ),
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
