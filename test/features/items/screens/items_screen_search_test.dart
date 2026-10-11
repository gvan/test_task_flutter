import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/pump_items_screen.dart';

const _inputDebounce = Duration(milliseconds: 500);

void main() {
  group('ItemsScreen: пошук по назві', () {
    testWidgets('знаходить товар за повною назвою', (tester) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);
      await _search(tester, 'Настільна лампа');
      expect(tester.toItemListIds(), [1]);
    });

    testWidgets('знаходить товари за частиною назви', (tester) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);
      await _search(tester, 'ка');
      expect(tester.toItemListIds(), [3, 4]);
    });

    testWidgets('пошук не залежить від регістру', (tester) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);
      await _search(tester, 'бЛоКнОт');
      expect(tester.toItemListIds(), [2]);
    });

    testWidgets('показує порожній стан, якщо нічого не знайдено', (
      tester,
    ) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);
      await _search(tester, 'ноутбук');
      expect(tester.toItemListIds(), isEmpty);
      expect(
        find.text('Немає товарів\nза заданими параметрами'),
        findsOneWidget,
      );
    });

    testWidgets('пошук запускається лише після паузи 500мс у введенні', (
      tester,
    ) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);

      await tester.enterText(_searchInput, 'лампа');
      await tester.pump(_inputDebounce - const Duration(milliseconds: 100));
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(tester.toItemListIds(), [1]);
    });

    testWidgets('кнопка очистити поле пошуку скидає пошук', (tester) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);
      await _search(tester, 'лампа');
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);
      expect(tester.widget<TextField>(_searchInput).controller!.text, isEmpty);
    });

    testWidgets('закриття поля пошуку скидає пошук', (tester) async {
      await tester.pumpItemsScreen();
      await _openSearch(tester);
      await _search(tester, 'лампа');

      await tester.tap(_searchToggle);
      await tester.pumpAndSettle();

      expect(_searchInput, findsNothing);
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);
    });
  });
}

final _searchToggle = find.descendant(
  of: find.byType(AppBar),
  matching: find.byIcon(Icons.search),
);

final _searchInput = find.byType(TextField);

Future<void> _openSearch(WidgetTester tester) async {
  await tester.tap(_searchToggle);
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(_searchInput, query);
  await tester.pump(_inputDebounce);
  await tester.pumpAndSettle();
}
