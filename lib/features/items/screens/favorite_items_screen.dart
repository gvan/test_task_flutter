import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/providers/favorite_items_provider.dart';
import 'package:test_task_flutter/features/items/providers/item_details_provider.dart';
import 'package:test_task_flutter/features/items/providers/state/favorite_items_state.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';
import 'package:test_task_flutter/features/items/screens/item_details_screen.dart';
import 'package:test_task_flutter/features/items/widgets/item_list_tile.dart';
import 'package:test_task_flutter/features/items/widgets/items_empty_view.dart';
import 'package:test_task_flutter/features/items/widgets/items_error_view.dart';

class FavoriteItemsScreen extends StatefulWidget {
  const FavoriteItemsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteItemsScreenState();
}

class _FavoriteItemsScreenState extends State<FavoriteItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FavoriteItemsProvider>();
      provider.watchFavoriteItems();
      provider.loadFavoriteItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteItemsProvider>();
    final state = provider.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Збережені товари')),
      body: SafeArea(child: _buildBody(state, provider)),
    );
  }

  Widget _buildBody(FavoriteItemsState state, FavoriteItemsProvider provider) {
    final items = state.favoriteItems;
    if (state.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && items.isEmpty) {
      return ItemsErrorView(
        message: state.errorMessage!,
        onRetry: provider.loadFavoriteItems,
      );
    }

    if (state.hasLoaded && items.isEmpty) {
      return ItemsEmptyView.favorite();
    }

    return ListView.separated(
      padding: const .fromLTRB(16, 12, 16, 24),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return ItemListTile(
          key: ValueKey(item.id),
          item: item,
          onPressed: _openDetails,
        );
      },
    );
  }

  void _openDetails(ItemModel item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              ItemDetailsProvider(context.read<IItemsRepository>(), item),
          child: ItemDetailsScreen(),
        ),
      ),
    );
  }
}
