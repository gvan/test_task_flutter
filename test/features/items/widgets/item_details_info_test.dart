import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/widgets/item_details_info.dart';

ItemModel _item(double rating) => ItemModel(
  id: 1,
  title: '',
  description: '',
  category: '',
  price: 1,
  rating: rating,
  colorValue: 0xFF7357A3,
  iconCodePoint: 0xe37c,
);

void main() {
  final ratings = {
    4.8: [1.0, 1.0, 1.0, 1.0, 0.8],
    3.2: [1.0, 1.0, 1.0, 0.2, 0.0],
    5.0: [1.0, 1.0, 1.0, 1.0, 1.0],
    0.0: [0.0, 0.0, 0.0, 0.0, 0.0],
  };

  for (final MapEntry(key: rating, value: expectedFills) in ratings.entries) {
    testWidgets('рейтинг $rating зафарбовує зірки як $expectedFills', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemDetailsInfo(
              item: _item(rating),
              color: const Color(0xFF7357A3),
            ),
          ),
        ),
      );

      final starWidgets = find.byType(RatingStar);
      expect(starWidgets, findsNWidgets(expectedFills.length));

      for (var i = 0; i < expectedFills.length; i++) {
        final starWidget = starWidgets.at(i);
        // Star's rating value match hardcoded value
        expect(
          tester.widget<RatingStar>(starWidget).rating,
          closeTo(expectedFills[i], 1e-9),
        );

        // Actual filled width match to calculated width
        final filledPart = tester.getSize(
          find.descendant(of: starWidget, matching: find.byType(ClipRect)),
        );
        expect(filledPart.width, closeTo(22.0 * expectedFills[i], 1e-9));
      }
    });
  }
}
