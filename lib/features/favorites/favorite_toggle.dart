import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/confirm_dialog.dart';

/// What every favorite heart does on tap: adding is instant, removing asks
/// for confirmation first so a stray tap can't drop a favorite.
Future<void> toggleFavoriteWithConfirm(
  BuildContext context,
  WidgetRef ref,
  Recipe recipe,
) async {
  final favorites = ref.read(favoritesProvider.notifier);
  if (!favorites.isFavorited(recipe.id)) {
    await favorites.addToFavorites(recipe);
    return;
  }

  final confirmed = await showConfirmDialog(
    context,
    title: 'Remove from favorites?',
    message: 'Remove "${recipe.name}" from your favorites?',
    confirmLabel: 'Yes, remove',
  );
  if (!confirmed || !context.mounted) return;
  await favorites.removeFromFavorites(recipe.id);
}
