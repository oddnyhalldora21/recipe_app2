import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/confirm_dialog.dart';
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

enum _RecipeAction { move, remove }

class _CollectionBody extends ConsumerWidget {
  const _CollectionBody({required this.collection, required this.recipes});

  final RecipeCollection collection;
  final List<Recipe> recipes;

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showDone(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Deletes only the collection — its recipes stay saved under All Saved.
  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete collection?',
      message:
          'This only deletes the collection. The recipes inside stay saved.',
      confirmLabel: 'Yes, delete',
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(savedRecipesProvider.notifier)
        .deleteCollection(collection.id);
    if (!context.mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      _showError(
        context,
        'Could not delete this collection — please try again.',
      );
    }
  }

  Future<void> _openRecipeMenu(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    final action = await showModalBottomSheet<_RecipeAction>(
      context: context,
      shape: _sheetShape,
      builder:
          (sheetContext) => _SheetFrame(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.drive_file_move_outline,
                  color: AppColors.pinkDeep,
                ),
                title: const Text('Move to another collection'),
                onTap: () => Navigator.pop(sheetContext, _RecipeAction.move),
              ),
              ListTile(
                leading: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.pinkDeep,
                ),
                title: const Text('Remove from this collection'),
                onTap: () => Navigator.pop(sheetContext, _RecipeAction.remove),
              ),
            ],
          ),
    );
    if (!context.mounted) return;

    switch (action) {
      case _RecipeAction.remove:
        await _remove(context, ref, recipe);
      case _RecipeAction.move:
        await _move(context, ref, recipe);
      case null:
        break;
    }
  }

  /// Un-files the recipe; it stays saved under All Saved.
  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    final success = await ref
        .read(savedRecipesProvider.notifier)
        .saveToAllSaved(recipe);
    if (!context.mounted) return;
    if (success) {
      _showDone(context, 'Removed from ${collection.name}');
    } else {
      _showError(context, 'Could not remove this recipe — please try again.');
    }
  }

  /// A saved recipe sits in one collection at a time, so filing it under
  /// another collection takes it out of this one in the same step.
  Future<void> _move(BuildContext context, WidgetRef ref, Recipe recipe) async {
    final others = [
      for (final other in ref.read(savedRecipesProvider).collections)
        if (other.id != collection.id) other,
    ];

    final target = await showModalBottomSheet<RecipeCollection>(
      context: context,
      shape: _sheetShape,
      isScrollControlled: true,
      builder:
          (sheetContext) => _SheetFrame(
            title: 'Move to…',
            children: [
              if (others.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 4, 24, 12),
                  child: Text(
                    'You have no other collections yet. Create one from the '
                    'save button on any recipe.',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final other in others)
                        ListTile(
                          leading: const Icon(
                            Icons.folder_rounded,
                            color: AppColors.pinkDeep,
                          ),
                          title: Text(other.name),
                          onTap: () => Navigator.pop(sheetContext, other),
                        ),
                    ],
                  ),
                ),
            ],
          ),
    );
    if (target == null || !context.mounted) return;

    final success = await ref
        .read(savedRecipesProvider.notifier)
        .saveToCollection(recipe, target.id);
    if (!context.mounted) return;
    if (success) {
      _showDone(context, 'Moved to ${target.name}');
    } else {
      _showError(context, 'Could not move this recipe — please try again.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            PopupMenuButton<String>(
              tooltip: 'Collection options',
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.brown),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (_) => _confirmAndDelete(context, ref),
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete collection'),
                    ),
                  ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child:
              recipes.isEmpty
                  ? Center(
                    child: Text(
                      'No recipes in this collection yet',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.brown.withOpacity(0.7),
                      ),
                    ),
                  )
                  : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: kRecipeCardWidth,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.68,
                        ),
                    itemCount: recipes.length,
                    // Not `context`: the menu needs the page's context,
                    // which stays mounted after this card leaves the grid.
                    itemBuilder: (itemContext, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        heroTag: 'collection_${collection.id}_${recipe.id}',
                        onMorePressed:
                            () => _openRecipeMenu(context, ref, recipe),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

const _sheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
);

/// Drag handle, optional title and options for the collection sheets, on
/// the app's white bottom-sheet theme.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(title!, style: AppText.serif(fontSize: 20)),
              ),
            ...children,
          ],
        ),
      ),
    );
  }
}
