import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/providers/item_details_provider.dart';
import 'package:test_task_flutter/features/items/providers/items_provider.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';
import 'package:test_task_flutter/features/items/screens/item_details_screen.dart';
import 'package:test_task_flutter/features/items/screens/items_screen.dart';

void main() {
  testWidgets(
    'Після сортування товарів оновлюються стейти айтемів в списку і вікривається правильний товар по кліку',
    (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<IItemsRepository>(
              create: (_) => ItemsRepository(),
              dispose: (_, repository) => repository.dispose(),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  ItemsProvider(context.read<IItemsRepository>()),
            ),
          ],
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
      final openedItem = tester
          .element(detailsScreen)
          .read<ItemDetailsProvider>()
          .state
          .item;
      expect(openedItem.id, 2);
    },
  );
}
