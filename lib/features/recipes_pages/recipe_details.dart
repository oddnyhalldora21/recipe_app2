import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/recipes_pages/save_bottom_sheet.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/widgets/cooking_time_card.dart';
import 'package:recipe_app/features/widgets/ingredients_section.dart';
import 'package:recipe_app/features/widgets/instructions_section.dart';
import 'package:recipe_app/features/widgets/recipe_image_frame.dart';
import 'package:recipe_app/shared/app_theme.dart';

class RecipeDetailsPage extends ConsumerWidget {
  const RecipeDetailsPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageFrame(
              imageUrl: recipe.imageUrl,
              favoriteButton: _FavoriteButton(recipe: recipe),
              saveButton: _SaveButton(recipe: recipe),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.category.toUpperCase(),
                    style: AppText.label.copyWith(
                      fontSize: 13,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.name,
                    style: AppText.serif(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CookingTimeCard(
                    cookingTime: recipe.cookingTime,
                    category: recipe.category,
                    ingredientCount: recipe.ingredients.length,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Ingredients section
            IngredientsSection(ingredients: recipe.ingredients),

            // Instructions section
            InstructionsSection(instructions: recipe.instructions),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(
      savedRecipesProvider.select((s) => s.isSaved(recipe.id)),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        onPressed: () => SaveBottomSheet.show(context, recipe),
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? AppColors.pinkDeep : AppColors.brown,
        ),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorited = favorites.any((r) => r.id == recipe.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        onPressed: () {
          ref.read(favoritesProvider.notifier).toggleFavorite(recipe);
        },
        icon: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          color: isFavorited ? AppColors.pinkDeep : AppColors.brown,
        ),
      ),
    );
  }
}
