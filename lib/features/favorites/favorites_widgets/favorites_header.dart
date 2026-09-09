import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/app_theme.dart';

class FavoritesHeader extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoritesHeader({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.pink,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Favorites', style: AppText.serif(fontSize: 26)),
            const SizedBox(height: 2),
            Text(
              '${favoriteRecipes.length} saved treat${favoriteRecipes.length == 1 ? '' : 's'}',
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}
