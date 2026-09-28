import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/responsive.dart';

class AllRecipesGrid extends StatelessWidget {
  final List<Recipe> allRecipes;
  final String heroTagPrefix;

  const AllRecipesGrid({
    super.key,
    required this.allRecipes,
    this.heroTagPrefix = 'allrecipes_page_',
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: kRecipeCardWidth,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.68,
      ),
      itemCount: allRecipes.length,
      itemBuilder: (context, index) {
        final recipe = allRecipes[index];
        return RecipeCard(
          recipe: recipe,
          heroTag: '$heroTagPrefix${recipe.id}',
        );
      },
    );
  }
}
