import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Meta pill row shown under the recipe title (cooking time + category).
class CookingTimeCard extends StatelessWidget {
  const CookingTimeCard({
    super.key,
    required this.cookingTime,
    required this.category,
    required this.ingredientCount,
  });

  final String cookingTime;
  final String category;
  final int ingredientCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _Pill(icon: Icons.timer_outlined, label: cookingTime),
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
