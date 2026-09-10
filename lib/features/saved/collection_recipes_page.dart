import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/saved/saved_empty_state.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

/// Shows just the recipes filed under one named collection.
class CollectionRecipesPage extends ConsumerWidget {
  const CollectionRecipesPage({super.key, required this.collection});

  final RecipeCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedRecipesProvider);
    final catalog = ref.watch(recipesCatalogProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: catalog.when(
            data:
                (allRecipes) => _CollectionBody(
                  collection: collection,
                  recipes: recipesForLocation(saved, collection.id, allRecipes),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: AppColors.pinkDeep),
                ),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    'Could not load this collection.',
                    style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _CollectionBody extends StatelessWidget {
  const _CollectionBody({required this.collection, required this.recipes});

  final RecipeCollection collection;
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.pink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.name, style: AppText.serif(fontSize: 26)),
                  const SizedBox(height: 2),
                  Text(
                    '${recipes.length} recipe${recipes.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child:
              recipes.isEmpty
                  ? const SavedEmptyState()
                  : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: kRecipeCardWidth,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.68,
                        ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        heroTag: 'collection_${collection.id}_${recipe.id}',
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
