import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class FavoritesHeader extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoritesHeader({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${favoriteRecipes.length} Favorite${favoriteRecipes.length == 1 ? '' : 's'}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 67, 47, 21),
      ),
    );
  }
}
