import 'package:flutter/material.dart';

class FilterAction extends StatelessWidget {
  const FilterAction({
    super.key,
    required this.categoryFilter,
    required this.categories,
    required this.onFilter,
  });

  final String categoryFilter;
  final List<String> categories;
  final Function(String) onFilter;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_alt_outlined),
      tooltip: 'Фільтрувати товари',
      onSelected: onFilter,
      itemBuilder: (menuContext) {
        PopupMenuItem<String> buildRadioItem(String value, String title) {
          return PopupMenuItem(
            value: value,
            padding: .zero,
            child: IgnorePointer(
              child: RadioGroup<String>(
                groupValue: categoryFilter,
                onChanged: (_) {},
                child: RadioListTile<String>(value: value, title: Text(title)),
              ),
            ),
          );
        }

        return [
          buildRadioItem('', 'Всі категорії'),
          for (final category in categories) buildRadioItem(category, category),
        ];
      },
    );
  }
}
