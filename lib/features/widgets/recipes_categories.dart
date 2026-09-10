import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_info.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_page.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class RecipesCategories extends ConsumerWidget {
  const RecipesCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(recipesCatalogProvider);

    return SizedBox(
      height: 96,
      child: catalog.when(
        data: (recipes) {
          final categories = categoriesFromRecipes(recipes);
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryTile(category: category);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemCount: categories.length,
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.pinkDeep),
            ),
        error:
            (error, stackTrace) => Center(
              child: Text(
                'Could not load categories.',
                style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
              ),
            ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final RecipeCategoryInfo category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          fadeRoute(
            RecipeCategoryPage(
              categorySlug: category.slug,
              categoryName: category.displayName,
              categoryImageUrl: category.imageUrl,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.pink, width: 2),
                ),
              ),
              child: ClipOval(
                child: Hero(
                  tag: category.slug,
                  child: Image.network(
                    category.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.pinkLight, AppColors.pink],
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.brown,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.pinkLight, AppColors.pink],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.cake,
                            size: 26,
                            color: AppColors.brown,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
