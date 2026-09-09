import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/responsive.dart';

class AllRecipesGrid extends StatelessWidget {
  final List<Recipe> allRecipes;

  const AllRecipesGrid({super.key, required this.allRecipes});

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
          itemCount: allRecipes.length,
          itemBuilder: (context, index) {
            final recipe = allRecipes[index];
            return RecipeCard(
              recipe: recipe,
              heroTag: 'allrecipes_page_${recipe.id}',
            );
          },
        );
      },
    );
  }
}
