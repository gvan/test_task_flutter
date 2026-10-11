import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/providers/items_provider.dart';
import 'package:test_task_flutter/features/items/repository/items_repository.dart';
import 'package:test_task_flutter/features/items/screens/items_screen.dart';

import '../../../fakes/fake_items_data_source.dart';

extension PumtItemsScreen on WidgetTester {
  Future<void> pumpItemsScreen() async {
    view.physicalSize = const Size(800, 2000);
    view.devicePixelRatio = 1;
    addTearDown(view.reset);

    await pumpWidget(
      MultiProvider(
        providers: [
          Provider<IItemsRepository>(
            create: (_) => ItemsRepository(dataSource: FakeItemsDataSource()),
            dispose: (_, repository) => repository.dispose(),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                ItemsProvider(context.read<IItemsRepository>()),
          ),
        ],
        child: const MaterialApp(home: ItemsScreen()),
      ),
    );
    await pumpAndSettle();
  }
}
