import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/profile_page/recipe_bottom_sheet.dart';
import 'package:recipe_app/features/recipes_pages/save_bottom_sheet.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/widgets/cooking_time_card.dart';
import 'package:recipe_app/features/widgets/ingredients_section.dart';
import 'package:recipe_app/features/widgets/instructions_section.dart';
import 'package:recipe_app/features/widgets/recipe_image_frame.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class RecipeDetailsPage extends ConsumerWidget {
  const RecipeDetailsPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner =
        recipe.userId != null &&
        recipe.userId == Supabase.instance.client.auth.currentUser?.id;

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
              editButton: isOwner ? _EditButton(recipe: recipe) : null,
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

class _EditButton extends StatelessWidget {
  const _EditButton({required this.recipe});

  final Recipe recipe;

  Future<void> _openEditForm(BuildContext context) async {
    final result = await AddRecipeBottomSheet.show(
      context,
      existingRecipe: recipe,
    );
    if (!context.mounted) return;

    if (result is RecipeUpdated) {
      Navigator.of(
        context,
      ).pushReplacement(fadeRoute(RecipeDetailsPage(recipe: result.recipe)));
    } else if (result is RecipeDeleted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        onPressed: () => _openEditForm(context),
        icon: const Icon(Icons.edit_outlined, color: AppColors.brown),
      ),
    );
  }
}
