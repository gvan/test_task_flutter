import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

import '../../../fakes/fake_items_data_source.dart';

void main() {
  late IItemsRepository repository;

  setUp(
    () => repository = ItemsRepository(
      dataSource: FakeItemsDataSource(items: [...testItems, extraItem]),
    ),
  );
  tearDown(() => repository.dispose());

  group('ItemsRepository.getCategories: отримння категорій', () {
    test('повертаються унікальні категорії', () async {
      final categories = await repository.getCategories();
      expect(categories.isNotEmpty, true);
      expect(categories.length, categories.toSet().toList().length);
    });
  });
}
