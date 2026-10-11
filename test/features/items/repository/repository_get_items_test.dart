import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

import '../../../fakes/fake_items_data_source.dart';
import '../utils/extension.dart';

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
      final repository = ItemsRepository(
        dataSource: FakeItemsDataSource(
          items: [
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
          ],
        ),
      );
      addTearDown(repository.dispose);

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

  group('ItemsRepository.getItems(): пошук по назві', () {
    test('пошук по назві', () async {
      final items = await repository.getItems(.original, '', 'лампа');
      expect(items.toIds(), [1]);
    });

    test('пошук не залежить від регістру', () async {
      final items = await repository.getItems(.original, '', 'БлОкНоТ');
      expect(items.toIds(), [2]);
    });

    test('перший пошук не впливає на наступний пошук', () async {
      await repository.getItems(.original, '', 'лампа');
      final items = await repository.getItems(.original, '', 'колонка');
      expect(items.toIds(), [3]);
    });
  });
}
