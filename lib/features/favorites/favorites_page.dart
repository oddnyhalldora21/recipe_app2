import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/favorites/favorites_widgets/favorites_empty_state.dart';
import 'package:recipe_app/features/favorites/favorites_widgets/favorites_header.dart';
import 'package:recipe_app/features/favorites/favorites_widgets/favorites_grid.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteRecipes = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        title: const Text(
          "My Favorites",
          style: TextStyle(
            color: Color.fromARGB(255, 67, 47, 21),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 67, 47, 21)),
      ),
      body:
          favoriteRecipes.isEmpty
              ? const FavoritesEmptyState()
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FavoritesHeader(favoriteRecipes: favoriteRecipes),
                    const SizedBox(height: 16),

                    Expanded(
                      child: FavoritesGrid(favoriteRecipes: favoriteRecipes),
                    ),
                  ],
                ),
              ),
    );
  }
}
