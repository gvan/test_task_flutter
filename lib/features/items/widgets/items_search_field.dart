import 'dart:async';

import 'package:flutter/material.dart';

class ItemsSearchField extends StatefulWidget {
  const ItemsSearchField({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  State<ItemsSearchField> createState() => _ItemsSearchFieldState();
}

class _ItemsSearchFieldState extends State<ItemsSearchField> {
  var _searchEmpty = true;
  TextEditingController? _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      padding: WidgetStatePropertyAll(.symmetric(horizontal: 16)),
      hintText: 'Назва товару',
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          widget.onSearch(value);
        });
        setState(() {
          _searchEmpty = value.trim().isEmpty;
        });
      },
      controller: _searchController,
      textInputAction: .search,
      onSubmitted: (value) {
        widget.onSearch(value);
      },
      leading: Icon(Icons.search),
      trailing: [
        if (!_searchEmpty)
          IconButton(
            onPressed: () {
              _searchController?.clear();
              widget.onSearch('');
              setState(() {
                _searchEmpty = true;
              });
            },
            icon: Icon(Icons.clear),
          ),
      ],
    );
  }
}
