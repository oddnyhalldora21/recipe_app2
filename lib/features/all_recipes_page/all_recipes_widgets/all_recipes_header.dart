import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class AllRecipesHeader extends StatelessWidget {
  final List<Recipe> allRecipes;

  const AllRecipesHeader({super.key, required this.allRecipes});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Here we have ${allRecipes.length} Sweet Treats',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 67, 47, 21),
      ),
    );
  }
}
