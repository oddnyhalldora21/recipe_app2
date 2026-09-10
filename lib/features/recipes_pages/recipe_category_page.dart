import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

class RecipeCategoryPage extends ConsumerWidget {
  const RecipeCategoryPage({
    super.key,
    required this.categorySlug,
    required this.categoryName,
    required this.categoryImageUrl,
  });

  final String categorySlug;
  final String categoryName;
  final String categoryImageUrl;

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
            Row(
              children: [
                Hero(
                  tag: categorySlug,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(categoryImageUrl),
                  ),
                ),
                const SizedBox(width: 14),
                Text(categoryName, style: AppText.serif(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: catalog.when(
                data: (allRecipes) {
                  final recipes =
                      allRecipes
                          .where((r) => r.category == categorySlug)
                          .toList();
                  final shown = recipes.length > 10 ? 10 : recipes.length;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: kRecipeCardWidth,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.68,
                        ),
                    itemCount: shown,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        heroTag: 'category_${categorySlug}_${recipe.id}',
                      );
                    },
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
