import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/pump_items_screen.dart';

void main() {
  group('ItemsScreen: фільтр', () {
    testWidgets('фільтр Всі категорії', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnFilter(tester, 'Всі категорії');
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);
    });

    testWidgets('фільтр Електроніка', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnFilter(tester, 'Електроніка');
      expect(tester.toItemListIds(), [3]);
    });

    testWidgets('поверенння до Всі категорії', (tester) async {
      await tester.pumpItemsScreen();
      await _tapOnFilter(tester, 'Аксесуари');
      await _tapOnFilter(tester, 'Всі категорії');
      expect(tester.toItemListIds(), [1, 2, 3, 4, 5]);
    });

    testWidgets('вибрано радіобатон поточного фільтра', (tester) async {
      final semantics = tester.ensureSemantics();
      final category = 'Електроніка';
      await tester.pumpItemsScreen();
      await _tapOnFilter(tester, category);

      await tester.tap(find.byIcon(Icons.filter_alt_outlined));
      await tester.pumpAndSettle();

      final items = find.byType(PopupMenuItem<String>);
      expect(items, findsWidgets);

      for (final item in tester.widgetList<PopupMenuItem<String>>(items)) {
        final isCurrent =
            item.value == (category == 'Всі категорії' ? '' : category);
        expect(
          tester.getSemantics(find.byWidget(item)),
          isSemantics(isChecked: isCurrent),
        );
      }
      semantics.dispose();
    });
  });
}

Future<void> _tapOnFilter(WidgetTester tester, String category) async {
  await tester.tap(find.byIcon(Icons.filter_alt_outlined));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(PopupMenuItem<String>, category));
  await tester.pumpAndSettle();
}
