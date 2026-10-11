import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';

import '../../../fakes/fake_items_data_source.dart';
import '../utils/extensions.dart';

void main() {
  late IItemsRepository repository;

  setUp(() => repository = ItemsRepository(dataSource: FakeItemsDataSource()));
  tearDown(() => repository.dispose());

  group(
    'ItemsRepository.toggleFavorite(): додавання/видалення обраних товарів',
    () {
      test('додавання і видалення товару в обране', () async {
        await repository.toggleFavorite(1);
        final favoriteItems = await repository.watchFavoriteItems().first;
        expect(favoriteItems.toIds(), [1]);

        await repository.toggleFavorite(1);
        final emptyItems = await repository.watchFavoriteItems().first;
        expect(emptyItems.toIds(), []);
      });

      test('додавання двох товарів до обраного', () async {
        await repository.toggleFavorite(2);
        await repository.toggleFavorite(3);
        final favoriteItems = await repository.watchFavoriteItems().first;
        expect(favoriteItems.toIds(), [2, 3]);
      });
    },
  );
}
