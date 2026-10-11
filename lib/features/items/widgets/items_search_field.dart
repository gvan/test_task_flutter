import 'dart:async';

import 'package:flutter/material.dart';

class ItemsSearchField extends StatefulWidget {
  const ItemsSearchField({
    super.key,
    required this.searchQuery,
    required this.showSearch,
    required this.onSearch,
  });

  final String searchQuery;
  final bool showSearch;
  final Function(String) onSearch;

  @override
  State<ItemsSearchField> createState() => _ItemsSearchFieldState();
}

class _ItemsSearchFieldState extends State<ItemsSearchField> {
  var _searchEmpty = true;
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant ItemsSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery != _searchController.text) {
          _debounce?.cancel();
          _searchController.text = widget.searchQuery;
          _searchEmpty = widget.searchQuery.trim().isEmpty;
        }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                        _searchController.clear();
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
