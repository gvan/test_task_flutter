import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/providers/state/items_state.dart';
import 'package:test_task_flutter/features/items/widgets/app_bar_actions/filter_action.dart';
import 'package:test_task_flutter/features/items/widgets/app_bar_actions/sort_action.dart';

import '../utils/extensions.dart';
import '../utils/pump_items_screen.dart';

const _allIds = [1, 2, 3, 4, 5];
const sortType = 'Ціна';
const category = 'Електроніка';
const query = 'лампа';

void main() {
  group('ItemsScreen: кнопка Скинути параметри', () {
    testWidgets('кнопка прихована, поки параметри не змінені', (tester) async {
      await tester.pumpItemsScreen();
      expect(_resetButton, findsNothing);
    });

    testWidgets('кнопка зʼявляється після зміни сортування', (tester) async {
      await tester.pumpItemsScreen();
      await _sortBy(tester, sortType);
      expect(_resetButton, findsOneWidget);
    });

    testWidgets('повертає початковий порядок', (tester) async {
      await tester.pumpItemsScreen();
      await _sortBy(tester, sortType);

      await _tapOnReset(tester);

      expect(tester.toItemListIds(), _allIds);
      expect(_sortAction(tester).initialValue, ItemsSort.original);
      expect(_resetButton, findsNothing);
    });

    testWidgets('кнопка зʼявляється після вибору категорії', (tester) async {
      await tester.pumpItemsScreen();
      await _filterBy(tester, category);
      expect(_resetButton, findsOneWidget);
    });

    testWidgets('повертає всі категорії', (tester) async {
      await tester.pumpItemsScreen();
      await _filterBy(tester, category);

      await _tapOnReset(tester);

      expect(tester.toItemListIds(), _allIds);
      expect(_filterAction(tester).categoryFilter, isEmpty);
      expect(_resetButton, findsNothing);
    });

    testWidgets('кнопка зʼявляється після пошуку', (tester) async {
      await tester.pumpItemsScreen();
      await _search(tester, query);
      expect(_resetButton, findsOneWidget);
    });

    testWidgets('очищує поле пошуку і повертає всі товари', (tester) async {
      await tester.pumpItemsScreen();
      await _search(tester, query);

      await _tapOnReset(tester);

      expect(tester.toItemListIds(), _allIds);
      expect(_searchText(tester), isEmpty);
      expect(_resetButton, findsNothing);
    });

    testWidgets('скидає сортування, фільтр і пошук одночасно', (tester) async {
      await tester.pumpItemsScreen();
      await _sortBy(tester, sortType);
      await _filterBy(tester, category);
      await _search(tester, query);
      expect(_resetButton, findsOneWidget);

      await _tapOnReset(tester);

      expect(tester.toItemListIds(), _allIds);
      expect(_sortAction(tester).initialValue, ItemsSort.original);
      expect(_filterAction(tester).categoryFilter, isEmpty);
      expect(_searchText(tester), isEmpty);
      expect(_resetButton, findsNothing);
    });

    testWidgets('скидання до кінця debounce пошуку не виконує пошук', (
      tester,
    ) async {
      await tester.pumpItemsScreen();
      // show the Reset button
      await _sortBy(tester, sortType);
      await _openSearch(tester);

      // input a search query and tap on the Reset button
      await tester.enterText(find.byType(TextField), query);
      await tester.pump(const Duration(milliseconds: 100));
      await _tapOnReset(tester);

      // wait for a delay
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(tester.toItemListIds(), _allIds);
      expect(_searchText(tester), isEmpty);
      expect(_resetButton, findsNothing);
    });
  });
}

final _resetButton = find.text('Скинути параметри');

Future<void> _tapOnReset(WidgetTester tester) async {
  await tester.tap(_resetButton);
  await tester.pumpAndSettle();
}

Future<void> _sortBy(WidgetTester tester, String option) async {
  await tester.tap(find.byIcon(Icons.sort));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option));
  await tester.pumpAndSettle();
}

Future<void> _filterBy(WidgetTester tester, String category) async {
  await tester.tap(find.byIcon(Icons.filter_alt_outlined));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(PopupMenuItem<String>, category));
  await tester.pumpAndSettle();
}

Future<void> _openSearch(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(AppBar),
      matching: find.byIcon(Icons.search),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String query) async {
  if (find.byType(TextField).evaluate().isEmpty) {
    await _openSearch(tester);
  }
  await tester.enterText(find.byType(TextField), query);
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

String _searchText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

SortAction _sortAction(WidgetTester tester) =>
    tester.widget<SortAction>(find.byType(SortAction));

FilterAction _filterAction(WidgetTester tester) =>
    tester.widget<FilterAction>(find.byType(FilterAction));
