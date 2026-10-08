import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/providers/items_provider.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';
import 'package:test_task_flutter/features/items/screens/item_details_screen.dart';
import 'package:test_task_flutter/features/items/screens/items_screen.dart';

void main() {
  testWidgets(
    'Після сортування товарів оновлюються стейти в списку і вікривається правильний товар по кліку',
    (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ItemsProvider(_MockItemsRepository()),
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Назва'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Блокнот'));
      await tester.pumpAndSettle();

      final detailsScreen = find.byType(ItemDetailsScreen);
      expect(detailsScreen, findsOneWidget);
      // Check that new item opens in details screen after sort
      expect(tester.widget<ItemDetailsScreen>(detailsScreen).item.id, 2);
    },
  );
}

// Create repository with mock data
class _MockItemsRepository implements IItemsRepository {
  @override
  Future<List<ItemModel>> getItems() async {
    return const [
      ItemModel(
        id: 1,
        title: 'Настільна лампа',
        description: '',
        category: '',
        price: 1.0,
        rating: 1.0,
        colorValue: 0xFF000000,
        iconCodePoint: 0xe37c,
      ),
      ItemModel(
        id: 2,
        title: 'Блокнот',
        description: '',
        category: '',
        price: 1.0,
        rating: 1.0,
        colorValue: 0xFF000000,
        iconCodePoint: 0xe0ef,
      ),
    ];
  }
}
