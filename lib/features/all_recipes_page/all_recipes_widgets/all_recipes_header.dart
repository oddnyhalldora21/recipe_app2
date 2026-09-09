import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/app_theme.dart';

class AllRecipesHeader extends StatelessWidget {
  final List<Recipe> allRecipes;

  const AllRecipesHeader({super.key, required this.allRecipes});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${allRecipes.length} recipes',
      style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
    );
  }
}
