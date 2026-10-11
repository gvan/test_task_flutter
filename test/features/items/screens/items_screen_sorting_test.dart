import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/providers/state/items_state.dart';
import 'package:test_task_flutter/features/items/widgets/app_bar_actions/sort_action.dart';

import '../utils/extensions.dart';
import '../utils/pump_items_screen.dart';

void main() {
  group('ItemsScreen: сортування', () {
    testWidgets('сортування за початковим порядком', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnSortBy(tester, 'Початковий порядок');
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);
    });

    testWidgets('сортування за назвою', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnSortBy(tester, 'Назва');
      expect(tester.toItemListIds(), [2, 1, 3, 5, 4]);
    });

    testWidgets('сортування за ціною', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnSortBy(tester, 'Ціна');
      expect(tester.toItemListIds(), [2, 4, 1, 5, 3]);
    });

    testWidgets('повернення до початкового порядку', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnSortBy(tester, 'Ціна');
      await _tapOnSortBy(tester, 'Початковий порядок');
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);
    });

    testWidgets('меню сортування отримує поточне сортування', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnSortBy(tester, 'Ціна');
      final sortAction = tester.widget<SortAction>(find.byType(SortAction));
      expect(sortAction.initialValue, ItemsSort.price);
    });
  });
}

Future<void> _tapOnSortBy(WidgetTester tester, String option) async {
  await tester.tap(find.byIcon(Icons.sort));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option));
  await tester.pumpAndSettle();
}
