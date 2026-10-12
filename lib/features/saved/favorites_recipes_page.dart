import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/saved/recipe_folder_view.dart';

/// The pinned Favorites folder on the Saved tab: a read-only view over
/// [favoritesProvider]. Un-favoriting goes through the card's heart and its
/// usual confirm dialog; there are no collection actions here.
class FavoritesRecipesPage extends ConsumerWidget {
  const FavoritesRecipesPage({super.key});

  /// Lets the app bar heart tell whether this page is already open.
  static const routeName = 'saved/favorites';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RecipeFolderView(
            icon: Icons.favorite_rounded,
            title: 'Favorites',
            recipes: favorites,
            heroTagPrefix: 'favorites',
            emptyState: const FolderEmptyMessage(
              'No favorites yet. Tap the heart on a recipe to add one.',
            ),
          ),
        ),
      ),
    );
  }
}
