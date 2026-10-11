import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

import '../../../fakes/fake_items_data_source.dart';
import '../utils/extension.dart';

void main() {
  late IItemsRepository repository;

  setUp(() => repository = ItemsRepository(dataSource: FakeItemsDataSource()));
  tearDown(() => repository.dispose());

  group('ItemsRepository.getItems(): фільтр по категорії', () {
    test('фільтр по категорії', () async {
      final items = await repository.getItems(.original, 'Канцелярія', '');
      expect(items.toIds(), [2]);
    });

    test('фільтр по категорії + пошук', () async {
      final items = await repository.getItems(.original, 'Аксесуари', 'a');
      expect(items.toIds(), [4]);
    });

    test('перший фільтр не впливає на наступний фільтр', () async {
      await repository.getItems(.original, 'Карцелярія', '');
      final items = await repository.getItems(.original, 'Електроніка', '');
      expect(items.toIds(), [3]);
    });
  });
}
