import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/items/screens/items_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Каталог товарів',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ItemsScreen(),
    );
  }
}
