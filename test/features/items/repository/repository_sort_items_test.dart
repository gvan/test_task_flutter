import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

import '../../../fakes/fake_items_data_source.dart';
import '../utils/extension.dart';

IItemsRepository _createRepositoryWith(List<ItemModel> items) {
  final repository = ItemsRepository(
    dataSource: FakeItemsDataSource(items: items),
  );
  addTearDown(repository.dispose);
  return repository;
}

void main() {
  late IItemsRepository repository;

  setUp(() => repository = ItemsRepository(dataSource: FakeItemsDataSource()));
  tearDown(() => repository.dispose());

  group('ItemsRepository.getItems(): сортування', () {
    test('сортування по id товару', () async {
      final items = await repository.getItems(.original, '', '');
      expect(items.toIds(), [1, 2, 3, 4, 5]);
    });

    test('сортування за назвою товару', () async {
      final items = await repository.getItems(.title, '', '');
      expect(items.map((e) => e.title), [
        'Блокнот',
        'Настільна лампа',
        'Портативна колонка',
        'Рюкзак',
        'Термопляшка',
      ]);
    });

    test('сорутвання за ціною', () async {
      final items = await repository.getItems(.price, '', '');
      expect(items.map((e) => e.price), [12.50, 29.95, 48.90, 64.40, 79.00]);
    });

    test('сортування по ціні + фільтрація по категорії', () async {
      // Add new product in the same category
      final repository = _createRepositoryWith([
        ...testItems,
        const ItemModel(
          id: 6,
          title: 'Ручка',
          description: 'Кулькова ручка.',
          category: 'Канцелярія',
          price: 2.00,
          rating: 3.9,
          colorValue: 0xFF557A46,
          iconCodePoint: 0xe0ef,
        ),
      ]);

      final items = await repository.getItems(.price, 'Канцелярія', '');

      expect(items.toIds(), [6, 2]);
    });

    test('сортування по ціні + пошук', () async {
      final items = await repository.getItems(.price, '', 'л');
      expect(items.toIds(), [2, 4, 1, 3]);
    });

    test('перше сортування не впливає на наступне сортування', () async {
      await repository.getItems(.price, '', '');
      final items = await repository.getItems(.original, '', '');
      expect(items.toIds(), [1, 2, 3, 4, 5]);
    });
  });
}
