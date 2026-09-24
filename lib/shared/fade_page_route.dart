import 'package:flutter/material.dart';
import 'package:recipe_app/shared/swipe_back_wrapper.dart';

/// Single consistent fade-in transition for every push navigation in the
/// app, so no call site has to pick its own transition style. Every pushed
/// page also gets [SwipeBackWrapper] for free, so swiping right pops it.
/// Pass [fullWidth]: false for a page with its own horizontal-scrolling
/// content (see [SwipeBackWrapper]'s doc) — defaults to true everywhere
/// else.
Route<T> fadeRoute<T>(Widget page, {bool fullWidth = true}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SwipeBackWrapper(fullWidth: fullWidth, child: page),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}
