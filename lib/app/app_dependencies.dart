import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_task_flutter/features/items/data_source/items_data_source.dart';

import '../features/items/providers/items_provider.dart';
import '../features/items/repository/items_repository.dart';
import 'app.dart';

class AppDependencies extends StatelessWidget {
  const AppDependencies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IItemsDataSource>(create: (_) => ItemsDataSource()),
        Provider<IItemsRepository>(
          create: (context) =>
              ItemsRepository(dataSource: context.read<IItemsDataSource>()),
          dispose: (_, repository) => repository.dispose(),
        ),
        ChangeNotifierProvider<ItemsProvider>(
          create: (context) => ItemsProvider(context.read<IItemsRepository>()),
        ),
      ],
      child: const App(),
    );
  }
}
