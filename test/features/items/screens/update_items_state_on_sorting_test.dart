import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/providers/item_details_provider.dart';
import 'package:test_task_flutter/features/items/screens/item_details_screen.dart';
import '../utils/pump_items_screen.dart';

void main() {
  testWidgets(
    'Після сортування товарів оновлюються стейти айтемів в списку і вікривається правильний товар по кліку',
    (tester) async {
      await tester.pumpItemsScreen();

      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Назва'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Блокнот'));
      await tester.pumpAndSettle();

      final detailsScreen = find.byType(ItemDetailsScreen);
      expect(detailsScreen, findsOneWidget);
      final openedItem = tester
          .element(detailsScreen)
          .read<ItemDetailsProvider>()
          .state
          .item;
      expect(openedItem.id, 2);
    },
  );
}
