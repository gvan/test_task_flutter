import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import '../providers/items_provider.dart';
import '../providers/state/items_state.dart';
import '../widgets/item_list_tile.dart';
import '../widgets/items_empty_view.dart';
import '../widgets/items_error_view.dart';
import 'item_details_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemsProvider>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemsProvider>();
    final state = provider.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог товарів'),
        actions: [
          PopupMenuButton<ItemsSort>(
            initialValue: state.sort,
            onSelected: provider.sortBy,
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
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(state, provider)),
    );
  }

  Widget _buildBody(ItemsState state, ItemsProvider provider) {
    final items = state.items;
    if (state.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && items.isEmpty) {
      return ItemsErrorView(
        message: state.errorMessage!,
        onRetry: provider.loadItems,
      );
    }
    if (state.hasLoaded && items.isEmpty) {
      return const ItemsEmptyView();
    }
    return RefreshIndicator(
      onRefresh: provider.loadItems,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemListTile(
            key: ValueKey(item.id),
            item: item,
            onPressed: _openDetails,
          );
        },
      ),
    );
  }

  void _openDetails(ItemModel item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ItemDetailsScreen(item: item)),
    );
  }
}
