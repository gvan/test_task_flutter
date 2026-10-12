import 'dart:async';

import 'package:flutter/material.dart';

class ItemsSearchField extends StatefulWidget {
  const ItemsSearchField({
    super.key,
    required this.searchQuery,
    required this.showSearch,
    required this.searchController,
    required this.onSearch,
  });

  final String searchQuery;
  final bool showSearch;
  final TextEditingController searchController;
  final Function(String) onSearch;

  @override
  State<ItemsSearchField> createState() => _ItemsSearchFieldState();
}

class _ItemsSearchFieldState extends State<ItemsSearchField> {
  var _searchEmpty = true;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topCenter,
        children: [...previousChildren, ?currentChild],
      ),
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        child: FadeTransition(opacity: animation, child: child),
        builder: (context, child) => ClipRect(
          clipBehavior: animation.isCompleted ? Clip.none : Clip.hardEdge,
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: animation.value,
            child: child,
          ),
        ),
      ),
      child: widget.showSearch
          ? Padding(
              key: const ValueKey('search'),
              padding: .fromLTRB(16, 8, 16, 8),
              child: SearchBar(
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
                controller: widget.searchController,
                textInputAction: .search,
                onSubmitted: (value) {
                  widget.onSearch(value);
                },
                leading: Icon(Icons.search),
                trailing: [
                  if (!_searchEmpty)
                    IconButton(
                      onPressed: () {
                        widget.searchController.clear();
                        widget.onSearch('');
                        setState(() {
                          _searchEmpty = true;
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                ],
              ),
            )
          : const SizedBox(key: ValueKey('no-search'), width: .infinity),
    );
  }
}
