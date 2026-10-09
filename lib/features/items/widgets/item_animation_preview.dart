import 'dart:math' as math;

import 'package:flutter/material.dart';

// The animated card with icon. The icon jumps and lands during animation.
// The background changes it's color by drawing circle from center to
// borders after icon jumping. The transition to previous state is done
// using reverse animation.
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

class _ItemAnimationPreviewState extends State<ItemAnimationPreview>
    with SingleTickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 700);

  static const _iconLandingAt = 0.4;
  static const _postLandingAt = 0.15;
  static const _iconMaxScale = 0.45;
  static const _iconLandingScale = 0.1;

  late final AnimationController _controller;
  late final Animation<double> _iconScaleUpAnimation;
  late final Animation<double> _iconLandingAnimation;
  late final Animation<double> _iconColorAnimation;
  late final Animation<double> _bgCircleAnimation;

  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: animationDuration);

    _iconScaleUpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 45,
      ),
    ]).animate(_interval(0, _iconLandingAt));

    _iconLandingAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 40),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
    ]).animate(_interval(_iconLandingAt, _iconLandingAt + _postLandingAt));

    _iconColorAnimation = CurvedAnimation(
      parent: _interval(_iconLandingAt, _iconLandingAt + _postLandingAt),
      curve: Curves.easeOut,
    );

    _bgCircleAnimation = CurvedAnimation(
      parent: _interval(_iconLandingAt, 1),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _interval(double begin, double end) =>
      CurvedAnimation(parent: _controller, curve: Interval(begin, end));

  void _onCardTap() {
    if (_controller.isAnimating) return;
    setState(() => _selected = !_selected);

    if (_selected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final background = Color.alphaBlend(
      color.withValues(alpha: 0.12),
      Theme.of(context).colorScheme.surface,
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        onTap: _onCardTap,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          child: SizedBox(
            height: 210,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final badgeSelected = _controller.value >= _iconLandingAt;
                final iconScaleUp = _iconScaleUpAnimation.value;
                final iconLandingScale = _iconLandingAnimation.value;
                final iconColor = _iconColorAnimation.value;
                final backgroundProgress = _bgCircleAnimation.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CirclePainter(
                          background: background,
                          fill: color,
                          progress: backgroundProgress,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale:
                          1 +
                          _iconMaxScale * iconScaleUp -
                          _iconLandingScale * iconLandingScale,
                      child: Icon(
                        widget.icon,
                        size: 88.0,
                        color: Color.lerp(color, Colors.white, iconColor),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: _StatusBadge(
                        selected: badgeSelected,
                        color: color,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.centerRight,
        children: [...previousChildren, ?currentChild],
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Badge(
        key: ValueKey(selected),
        backgroundColor: selected ? Colors.white : color,
        label: Padding(
          padding: const .all(2),
          child: Row(
            mainAxisSize: .min,
            children: [
              if (selected) ...[
                Icon(Icons.check_rounded, size: 14, color: color),
                const SizedBox(width: 2),
              ],
              Text(
                selected ? 'Обрано' : 'Натисни',
                style: TextStyle(color: selected ? color : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  const _CirclePainter({
    required this.background,
    required this.fill,
    required this.progress,
  });

  final Color background;
  final Color fill;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    if (progress == 0) return;
    final rectangleRadius =
        math.sqrt(size.width * size.width + size.height * size.height) / 2;
    final currentRadius = rectangleRadius * progress;
    canvas.drawCircle(
      size.center(Offset.zero),
      currentRadius,
      Paint()..color = fill,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.background != background ||
      oldDelegate.fill != fill;
}
