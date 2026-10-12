import 'dart:async';

import 'package:flutter/material.dart';

class ItemsSearchField extends StatefulWidget {
  const ItemsSearchField({
    super.key,
    required this.showSearch,
    required this.searchController,
    required this.onSearch,
  });

  final bool showSearch;
  final TextEditingController searchController;
  final Function(String) onSearch;

  @override
  State<ItemsSearchField> createState() => _ItemsSearchFieldState();
}

class _ItemsSearchFieldState extends State<ItemsSearchField> {
  var _searchEmpty = true;
  Timer? _debounce;
  String _pendingText = '';

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.searchController.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final text = widget.searchController.text;
    if (text != _pendingText) _debounce?.cancel();
    final empty = text.trim().isEmpty;
    if (empty != _searchEmpty) {
      setState(() {
        _searchEmpty = empty;
      });
    }
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
                  _pendingText = value;
                  _debounce?.cancel();
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
                  _debounce?.cancel();
                  widget.onSearch(value);
                },
                leading: Icon(Icons.search),
                trailing: [
                  if (!_searchEmpty)
                    IconButton(
                      onPressed: () {
                        widget.searchController.clear();
                        widget.onSearch('');
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
