import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

/// Header plus recipe grid shared by every folder opened from the Saved
/// tab — Favorites, All Saved and the user's collections.
class RecipeFolderView extends StatelessWidget {
  const RecipeFolderView({
    super.key,
    required this.icon,
    required this.title,
    required this.recipes,
    required this.heroTagPrefix,
    required this.emptyState,
    this.headerAction,
    this.onRecipeMorePressed,
  });

  final IconData icon;
  final String title;
  final List<Recipe> recipes;
  final String heroTagPrefix;
  final Widget emptyState;

  /// Folder-level menu beside the title; null hides it.
  final Widget? headerAction;

  /// Per-recipe ⋮ button on each card; null hides it.
  final void Function(Recipe recipe)? onRecipeMorePressed;

  @override
  Widget build(BuildContext context) {
    final onMore = onRecipeMorePressed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // A small plain arrow on its own line above the folder icon, so the
        // header row only holds the icon, title and menu.
        IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.brown,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.pink,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.serif(fontSize: 26)),
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
            if (headerAction != null) headerAction!,
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child:
              recipes.isEmpty
                  ? emptyState
                  : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: kRecipeCardWidth,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.68,
                        ),
                    itemCount: recipes.length,
                    itemBuilder: (_, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        heroTag: '${heroTagPrefix}_${recipe.id}',
                        onMorePressed:
                            onMore == null ? null : () => onMore(recipe),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

/// Muted one-line message for an empty folder.
class FolderEmptyMessage extends StatelessWidget {
  const FolderEmptyMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.brown.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
