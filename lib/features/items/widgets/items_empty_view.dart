import 'package:flutter/material.dart';

class ItemsEmptyView extends StatelessWidget {
  const ItemsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48),
          SizedBox(height: 12),
          Text('Товарів поки немає'),
        ],
      ),
    );
  }
}
