import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/favorites/favorites_widgets/favorites_empty_state.dart';
import 'package:recipe_app/features/favorites/favorites_widgets/favorites_header.dart';
import 'package:recipe_app/features/favorites/favorites_widgets/favorites_grid.dart';
import 'package:recipe_app/shared/app_theme.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteRecipes = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child:
            favoriteRecipes.isEmpty
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FavoritesHeader(favoriteRecipes: favoriteRecipes),
                      const Expanded(child: FavoritesEmptyState()),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FavoritesHeader(favoriteRecipes: favoriteRecipes),
                      const SizedBox(height: 20),

                      Expanded(
                        child: FavoritesGrid(favoriteRecipes: favoriteRecipes),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
