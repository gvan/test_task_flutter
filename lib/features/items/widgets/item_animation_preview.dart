import 'package:flutter/material.dart';

class ItemAnimationPreview extends StatefulWidget {
  const ItemAnimationPreview({
    super.key,
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  State<ItemAnimationPreview> createState() => _ItemAnimationPreviewState();
}

class _ItemAnimationPreviewState extends State<ItemAnimationPreview> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => setState(() => _active = !_active),
      child: Container(
        height: 210,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(widget.icon, size: 88, color: widget.color),
            Positioned(
              right: 16,
              top: 16,
              child: Badge(
                label: Text(_active ? 'Обрано' : 'Натисни'),
                backgroundColor: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
