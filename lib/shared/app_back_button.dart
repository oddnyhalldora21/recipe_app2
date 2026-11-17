import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Round white back button matching the floating Save/Favorite buttons on
/// the recipe photo, so every pushed page can be left with a tap as well as
/// [SwipeBackWrapper]'s swipe.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.brown,
        ),
      ),
    );
  }
}
