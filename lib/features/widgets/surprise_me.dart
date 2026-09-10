import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

class SurpriseMe extends ConsumerWidget {
  const SurpriseMe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(recipesCatalogProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 215,
        child: catalog.when(
          data: (recipes) {
            final randomRecipes = RecipeService.randomRecipes(recipes, 3);
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final recipe = randomRecipes[index];
                return SizedBox(
                  width: kRecipeCardWidth,
                  child: RecipeCard(
                    recipe: recipe,
                    heroTag: 'surprise_${recipe.id}',
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemCount: randomRecipes.length,
            );
          },
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: AppColors.pinkDeep),
              ),
          error:
              (error, stackTrace) => Center(
                child: Text(
                  'Could not load recipes.',
                  style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                ),
              ),
        ),
      ),
    );
  }
}
