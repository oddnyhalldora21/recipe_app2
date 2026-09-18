import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipes_pages/save_bottom_sheet.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
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
              deleteButton: isOwner ? _DeleteButton(recipe: recipe) : null,
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

class _DeleteButton extends ConsumerWidget {
  const _DeleteButton({required this.recipe});

  final Recipe recipe;

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete this recipe?'),
            content: Text(
              '"${recipe.name}" will be permanently deleted. This can\'t be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(userRecipesProvider.notifier)
        .removeRecipe(recipe.id);
    if (!context.mounted) return;

    if (success) {
      // The catalog cache may still hold this recipe if it was public —
      // drop it so it doesn't linger stale on Home/All Recipes/etc.
      ref.invalidate(recipesCatalogProvider);
      Navigator.of(context).pop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not delete this recipe — please try again.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        onPressed: () => _confirmAndDelete(context, ref),
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      ),
    );
  }
}
