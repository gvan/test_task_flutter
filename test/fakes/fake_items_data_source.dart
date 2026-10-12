import 'package:test_task_flutter/features/items/data_source/items_data_source.dart';
import 'package:test_task_flutter/features/items/models/item_model.dart';

const testItems = [
  ItemModel(
    id: 1,
    title: 'Настільна лампа',
    description: 'Компактна атмосферна лампа з регулюванням теплого світла.',
    category: 'Освітлення',
    price: 48.90,
    rating: 4.8,
    colorValue: 0xFF7357A3,
    iconCodePoint: 0xe37c,
  ),
  ItemModel(
    id: 3,
    title: 'Портативна колонка',
    description: 'Портативна бездротова колонка в мінімалістичному корпусі.',
    category: 'Електроніка',
    price: 79.00,
    rating: 4.6,
    colorValue: 0xFFB5533C,
    iconCodePoint: 0xe050,
  ),
  ItemModel(
    id: 2,
    title: 'Блокнот',
    description: 'Міцний нотатник для ідей, ескізів і планів.',
    category: 'Канцелярія',
    price: 12.50,
    rating: 4.3,
    colorValue: 0xFF557A46,
    iconCodePoint: 0xe0ef,
  ),
  ItemModel(
    id: 4,
    title: 'Термопляшка',
    description: 'Термостійка сталева пляшка для щоденного використання.',
    category: 'Аксесуари',
    price: 29.95,
    rating: 4.5,
    colorValue: 0xFF247D81,
    iconCodePoint: 0xe6dd,
  ),
  ItemModel(
    id: 5,
    title: 'Рюкзак',
    description: 'Легкий рюкзак із м’яким відділенням для ноутбука.',
    category: 'Сумки та рюкзаки',
    price: 64.40,
    rating: 4.7,
    colorValue: 0xFF9A6B35,
    iconCodePoint: 0xe2c8,
  ),
];

const extraItem = ItemModel(
  id: 6,
  title: 'Ручка',
  description: 'Кулькова ручка.',
  category: 'Канцелярія',
  price: 2.00,
  rating: 3.9,
  colorValue: 0xFF557A46,
  iconCodePoint: 0xe0ef,
);

class FakeItemsDataSource implements IItemsDataSource {
  FakeItemsDataSource({this.items = testItems});

  final List<ItemModel> items;
  final Set<int> _favoriteIds = {};

  @override
  Future<List<ItemModel>> getItems() async => items;

  @override
  Future<List<String>> getCategories() async =>
      items.map((e) => e.category).toSet().toList();

  @override
  Future<List<int>> getFavorites() async {
    return _favoriteIds.toList();
  }

  @override
  Future<void> toggleFavorite(int itemId) async {
    if (_favoriteIds.contains(itemId)) {
      _favoriteIds.remove(itemId);
    } else {
      _favoriteIds.add(itemId);
    }
  }
}
