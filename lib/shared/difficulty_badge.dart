import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Difficulty as filled dots plus a label (●○○ Easy, ●●○ Medium, ●●● Hard),
/// shared by the recipe card and the detail page so they always match.
class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.onPhoto = false,
  });

  final RecipeDifficulty difficulty;

  /// Smaller, white-backed variant for sitting on top of a card's photo,
  /// matching the card's other floating pills.
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final filled = difficulty.index + 1;
    final dotSize = onPhoto ? 5.0 : 6.0;

    return Container(
      padding:
          onPhoto
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            onPhoto
                ? Colors.white.withValues(alpha: 0.92)
                : AppColors.pinkLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: onPhoto ? AppShadows.soft : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < RecipeDifficulty.values.length; i++)
            Container(
              width: dotSize,
              height: dotSize,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    i < filled
                        ? AppColors.pinkDark
                        : AppColors.pinkDark.withValues(alpha: 0.25),
              ),
            ),
          const SizedBox(width: 4),
          Text(
            onPhoto ? difficulty.label : difficulty.label.toUpperCase(),
            style: TextStyle(
              fontSize: onPhoto ? 10 : 11,
              fontWeight: FontWeight.w700,
              letterSpacing: onPhoto ? 0 : 0.8,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
