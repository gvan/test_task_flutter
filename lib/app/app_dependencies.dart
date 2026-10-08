import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../features/items/providers/items_provider.dart';
import '../features/items/repository/items_repository.dart';
import 'app.dart';

class AppDependencies extends StatelessWidget {
  const AppDependencies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IItemsRepository>(create: (_) => ItemsRepository()),
        ChangeNotifierProvider<ItemsProvider>(
          create: (context) => ItemsProvider(context.read<IItemsRepository>()),
        ),
      ],
      child: const App(),
    );
  }
}
