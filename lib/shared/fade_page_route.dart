import 'package:flutter/material.dart';
import 'package:recipe_app/shared/swipe_back_wrapper.dart';

/// Single consistent fade-in transition for every push navigation in the
/// app, so no call site has to pick its own transition style. Every pushed
/// page also gets [SwipeBackWrapper] for free, so swiping right from the
/// left edge pops it like the native iOS back gesture.
Route<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SwipeBackWrapper(child: page),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}
