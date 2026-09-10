import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes_header.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes_grid.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

class AllRecipesPage extends ConsumerWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(recipesCatalogProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Recipes', style: AppText.serif(fontSize: 26)),
            const SizedBox(height: 4),
            Expanded(
              child: catalog.when(
                data: (recipes) {
                  final allRecipes = RecipeService.shuffle(recipes);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AllRecipesHeader(allRecipes: allRecipes),
                      const SizedBox(height: 16),
                      Expanded(
                        child: AllRecipesGrid(allRecipes: allRecipes),
                      ),
                    ],
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.pinkDeep,
                      ),
                    ),
                error:
                    (error, stackTrace) => Center(
                      child: Text(
                        'Could not load recipes.',
                        style: TextStyle(
                          color: AppColors.brown.withOpacity(0.7),
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
