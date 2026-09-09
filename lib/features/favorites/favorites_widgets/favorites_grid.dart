import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/responsive.dart';

class FavoritesGrid extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoritesGrid({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: recipeGridColumns(constraints.maxWidth),
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.68,
          ),
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = favoriteRecipes[index];
            return RecipeCard(recipe: recipe, heroTag: 'favorites_${recipe.id}');
          },
        );
      },
    );
  }
}
