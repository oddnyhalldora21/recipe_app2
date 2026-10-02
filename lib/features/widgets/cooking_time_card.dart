import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Meta pill row shown under the recipe title. Each pill only appears when
/// its value exists, so older recipes without the newer details show just
/// the ingredient count. No category pill — the label above the title
/// already shows it.
class CookingTimeCard extends StatelessWidget {
  const CookingTimeCard({
    super.key,
    required this.cookingTime,
    required this.ingredientCount,
    this.details = const RecipeDetails(),
  });

  final String cookingTime;
  final int ingredientCount;
  final RecipeDetails details;

  /// The form stores oven temp as typed, so a bare number like "180" gets
  /// °C added; anything already carrying a unit is shown unchanged.
  static String _displayOvenTemp(String value) =>
      RegExp(r'^\d+$').hasMatch(value) ? '$value°C' : value;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
          _Pill(
            icon: Icons.thermostat_outlined,
            label: _displayOvenTemp(details.ovenTemp!),
          ),
        if (details.servings != null)
          _Pill(
            icon: Icons.people_outline,
            label: 'Serves ${details.servings}',
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.pinkLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.pinkDeep),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
