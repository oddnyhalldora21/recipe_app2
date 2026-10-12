import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/saved/recipe_folder_view.dart';
import 'package:recipe_app/features/saved/saved_empty_state.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Every saved recipe, filed under a collection or not.
class AllSavedPage extends ConsumerWidget {
  const AllSavedPage({super.key});

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
                (allRecipes) => RecipeFolderView(
                  icon: Icons.bookmark_rounded,
                  title: 'All Saved',
                  recipes: recipesForLocation(saved, null, allRecipes),
                  heroTagPrefix: 'saved',
                  emptyState: const SavedEmptyState(),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: AppColors.pinkDeep),
                ),
            error:
                (error, stackTrace) => const FolderEmptyMessage(
                  'Could not load your saved recipes.',
                ),
          ),
        ),
      ),
    );
  }
}
