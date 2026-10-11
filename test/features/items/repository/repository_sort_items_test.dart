import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/providers/state/items_state.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

import '../../../fakes/fake_items_data_source.dart';

List<int> _idsFromItems(List<ItemModel> items) =>
    items.map((e) => e.id).toList();

ItemsRepository _createRepositoryWith(List<ItemModel> items) {
  final repository = ItemsRepository(
    dataSource: FakeItemsDataSource(items: items),
  );
  addTearDown(repository.dispose);
  return repository;
}

void main() {
  late ItemsRepository repository;

  setUp(() => repository = ItemsRepository(dataSource: FakeItemsDataSource()));
  tearDown(() => repository.dispose());

  group('ItemsRepository.getItems(): сортування', () {
    test('сортування по id товару', () async {
      final items = await repository.getItems(ItemsSort.original, '', '');
      expect(_idsFromItems(items), [1, 2, 3, 4, 5]);
    });

    test('сортування за назвою товару', () async {
      final items = await repository.getItems(ItemsSort.title, '', '');
      expect(items.map((e) => e.title), [
        'Блокнот',
        'Настільна лампа',
        'Портативна колонка',
        'Рюкзак',
        'Термопляшка',
      ]);
    });

    test('сорутвання за ціною', () async {
      final items = await repository.getItems(ItemsSort.price, '', '');
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

      final items = await repository.getItems(
        ItemsSort.price,
        'Канцелярія',
        '',
      );

      expect(_idsFromItems(items), [6, 2]);
    });

    test('сортування по ціні + пошук', () async {
      final items = await repository.getItems(ItemsSort.price, '', 'л');
      expect(_idsFromItems(items), [2, 4, 1, 3]);
    });

    test('сортування не впливає на наступне сортування', () async {
      await repository.getItems(ItemsSort.price, '', '');
      final items = await repository.getItems(ItemsSort.original, '', '');

      expect(_idsFromItems(items), [1, 2, 3, 4, 5]);
    });
  });
}
