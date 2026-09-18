import 'package:flutter/material.dart';

/// Wraps a pushed page so dragging right from the screen's left edge pops
/// it, mirroring the native iOS back gesture. [fadeRoute] applies this to
/// every push in the app, so it works alongside — not instead of — the
/// logo's "jump straight to Home" navigation.
class SwipeBackWrapper extends StatefulWidget {
  const SwipeBackWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<SwipeBackWrapper> createState() => _SwipeBackWrapperState();
}

class _SwipeBackWrapperState extends State<SwipeBackWrapper>
    with SingleTickerProviderStateMixin {
  static const double _edgeWidth = 24;
  static const double _popDistanceFraction = 0.35;
  static const double _flingVelocity = 300;

  late final AnimationController _settleController;
  Animation<double>? _settleAnimation;
  double _dragExtent = 0;

  @override
  void initState() {
    super.initState();
    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
      setState(() => _dragExtent = _settleAnimation!.value);
    });
  }

  @override
  void dispose() {
    _settleController.dispose();
    super.dispose();
  }

  void _runSettle(double target, {VoidCallback? onDone}) {
    _settleAnimation = Tween<double>(
      begin: _dragExtent,
      end: target,
    ).animate(CurvedAnimation(parent: _settleController, curve: Curves.easeOut));
    _settleController
      ..stop()
      ..reset()
      ..forward().whenComplete(() {
        if (onDone != null) onDone();
      });
  }

  void _handleDragUpdate(DragUpdateDetails details, double width) {
    setState(() {
      _dragExtent = (_dragExtent + details.delta.dx).clamp(0, width);
    });
  }

  void _handleDragEnd(DragEndDetails details, double width) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldPop =
        velocity > _flingVelocity || _dragExtent > width * _popDistanceFraction;
    if (shouldPop) {
      _runSettle(
        width,
        onDone: () {
          if (mounted) Navigator.of(context).pop();
        },
      );
    } else {
      _runSettle(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nothing to go back to (e.g. a tab's root page) — skip the gesture
    // entirely so it never eats an edge touch for no reason.
    if (!Navigator.of(context).canPop()) return widget.child;

    final width = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        Transform.translate(
          offset: Offset(_dragExtent, 0),
          child: _dragExtent > 0
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(-4, 0),
                      ),
                    ],
                  ),
                  child: widget.child,
                )
              : widget.child,
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: _edgeWidth,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (_) => _settleController.stop(),
            onHorizontalDragUpdate: (d) => _handleDragUpdate(d, width),
            onHorizontalDragEnd: (d) => _handleDragEnd(d, width),
            onHorizontalDragCancel: () => _runSettle(0),
          ),
        ),
      ],
    );
  }
}
