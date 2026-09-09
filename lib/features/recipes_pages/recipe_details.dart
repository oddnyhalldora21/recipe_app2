import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageFrame(
              imageUrl: recipe.imageUrl,
              onBack: () => Navigator.of(context).maybePop(),
              favoriteButton: _FavoriteButton(recipe: recipe),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                      color: AppColors.pinkDeep,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CookingTimeCard(
                    cookingTime: recipe.cookingTime,
                    category: recipe.category,
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
