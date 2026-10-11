import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/screens/favorite_items_screen.dart';
import 'package:test_task_flutter/features/items/screens/item_details_screen.dart';

import '../utils/extensions.dart';
import '../utils/pump_items_screen.dart';

void main() {
  group('Обране: екран збережених товарів', () {
    testWidgets('порожній, поки нічого не збережено', (tester) async {
      await tester.pumpItemsScreen();

      await _openFavoriteScreen(tester);

      expect(tester.toItemListIds(), isEmpty);
      expect(find.text('Немає збережених товарів'), findsOneWidget);
    });

    testWidgets('показує збережені товари', (tester) async {
      await tester.pumpItemsScreen();
      await _addToFavorite(tester, 'Блокнот');
      await _addToFavorite(tester, 'Рюкзак');

      await _openFavoriteScreen(tester);

      expect(tester.toItemListIds(), unorderedEquals([2, 5]));
    });

    testWidgets('не показує товар, видалений з обраного', (tester) async {
      await tester.pumpItemsScreen();
      await _addToFavorite(tester, 'Блокнот');
      await _addToFavorite(tester, 'Рюкзак');
      await _addToFavorite(tester, 'Блокнот');

      await _openFavoriteScreen(tester);

      expect(tester.toItemListIds(), [5]);
    });

    testWidgets(
      'видалення на екрані деталей одразу оновлює список збережених',
      (tester) async {
        await tester.pumpItemsScreen();
        await _addToFavorite(tester, 'Блокнот');
        await _openFavoriteScreen(tester);
        await _addToFavorite(tester, 'Блокнот');
        expect(find.byType(FavoriteItemsScreen), findsOneWidget);
        expect(tester.toItemListIds(), isEmpty);
        expect(find.text('Немає збережених товарів'), findsOneWidget);
      },
    );
  });
}

Future<void> _addToFavorite(WidgetTester tester, String title) async {
  await _openItemDetailsScreen(tester, title);
  await _tapOnFavoriteButton(tester);
  await _goBack(tester);
}

Future<void> _openItemDetailsScreen(WidgetTester tester, String title) async {
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
  expect(find.byType(ItemDetailsScreen), findsOneWidget);
}

Future<void> _openFavoriteScreen(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.favorite_outline));
  await tester.pumpAndSettle();
  expect(find.byType(FavoriteItemsScreen), findsOneWidget);
}

Future<void> _goBack(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

Future<void> _tapOnFavoriteButton(WidgetTester tester) async {
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}
