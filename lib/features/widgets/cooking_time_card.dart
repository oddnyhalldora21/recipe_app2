import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Meta pill row shown under the recipe title. Each pill only appears when
/// its value exists, so older recipes without the newer details show just
/// category + ingredient count, as before.
class CookingTimeCard extends StatelessWidget {
  const CookingTimeCard({
    super.key,
    required this.cookingTime,
    required this.category,
    required this.ingredientCount,
    this.details = const RecipeDetails(),
  });

  final String cookingTime;
  final String category;
  final int ingredientCount;
  final RecipeDetails details;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (cookingTime.isNotEmpty)
          _Pill(icon: Icons.timer_outlined, label: cookingTime),
        if (details.prepMinutes != null)
          _Pill(
            icon: Icons.timer_outlined,
            label: 'Prep ${formatMinutes(details.prepMinutes!)}',
          ),
        // No-bake recipes never show bake time or oven temp, even if a
        // stale value were somehow stored.
        if (!details.isNoBake && details.bakeMinutes != null)
          _Pill(
            icon: Icons.local_fire_department_outlined,
            label: 'Bake ${formatMinutes(details.bakeMinutes!)}',
          ),
        if (!details.isNoBake && details.ovenTemp != null)
          _Pill(icon: Icons.thermostat_outlined, label: details.ovenTemp!),
        if (details.servings != null)
          _Pill(
            icon: Icons.people_outline,
            label: 'Serves ${details.servings}',
          ),
        _Pill(icon: Icons.local_dining_outlined, label: category),
        _Pill(
          icon: Icons.shopping_basket_outlined,
          label: '$ingredientCount ingredients',
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.pinkLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.pinkDeep),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
