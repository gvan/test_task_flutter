import 'package:flutter/material.dart';

class ItemsByParametersEmptyView extends StatelessWidget {
  const ItemsByParametersEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48),
          SizedBox(height: 12),
          Text('Немає товарів\nза заданими параметрами', textAlign: .center),
        ],
      ),
    );
  }
}
