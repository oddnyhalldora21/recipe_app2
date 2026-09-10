import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_list_home_page.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

class RecipeCategoryPage extends ConsumerWidget {
  const RecipeCategoryPage({super.key, required this.recipeCategoryList});

  final RecipeCategoryList recipeCategoryList;

  /// Maps the category list's display name to the slug stored in
  /// recipes_sweettreats.category (e.g. "No Sugar" -> "sugar-free").
  String _categorySlug(String displayName) {
    switch (displayName.toLowerCase()) {
      case 'chocolate':
        return 'chocolate';
      case 'puff pastry':
        return 'puff-pastry';
      case 'gluten free':
        return 'gluten-free';
      case 'frozen':
        return 'frozen';
      case 'cookies':
        return 'cookies';
      case 'vegan':
        return 'vegan';
      case 'no bake':
        return 'no-bake';
      case 'no sugar':
        return 'sugar-free';
      default:
        return displayName.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(recipesCatalogProvider);
    final slug = _categorySlug(recipeCategoryList.name);

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
              child: catalog.when(
                data: (allRecipes) {
                  final recipes =
                      allRecipes.where((r) => r.category == slug).toList();
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final shown = recipes.length > 10 ? 10 : recipes.length;
                      return GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: recipeGridColumns(
                                constraints.maxWidth,
                              ),
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
