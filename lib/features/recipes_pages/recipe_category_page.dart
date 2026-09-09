import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_list_home_page.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

class RecipeCategoryPage extends ConsumerWidget {
  const RecipeCategoryPage({super.key, required this.recipeCategoryList});

  final RecipeCategoryList recipeCategoryList;

  List<Recipe> getRecipesByCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'chocolate':
        return ChocolateRecipes.getAllChocolateRecipes();
      case 'puff pastry':
        return PuffPastryRecipes.getAllPuffPastryRecipes();
      case 'gluten free':
        return GlutenFreeRecipes.getAllGlutenFreeRecipes();
      case 'frozen':
        return FrozenTreatsRecipes.getAllFrozenTreatsRecipes();
      case 'cookies':
        return CookieRecipes.getAllCookieRecipes();
      case 'vegan':
        return VeganRecipes.getAllVeganRecipes();
      case 'no bake':
        return NoBakeRecipes.getAllNoBakeRecipes();
      case 'no sugar':
        return SugarFreeRecipes.getAllSugarFreeRecipes();
      default:
        return ChocolateRecipes.getAllChocolateRecipes(); // Default fallback
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = getRecipesByCategory(recipeCategoryList.name);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: recipeCategoryList.id,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(recipeCategoryList.imageUrl),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  recipeCategoryList.name,
                  style: AppText.serif(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final shown = recipes.length > 10 ? 10 : recipes.length;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: recipeGridColumns(constraints.maxWidth),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: shown,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        heroTag:
                            'category_${recipeCategoryList.id}_${recipe.id}',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
