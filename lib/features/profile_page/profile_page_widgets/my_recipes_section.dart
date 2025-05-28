import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class MyRecipesSection extends StatelessWidget {
  final List<Recipe> userRecipes;

  const MyRecipesSection({super.key, required this.userRecipes});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Recipes (${userRecipes.length})',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
        ),
        if (userRecipes.isNotEmpty)
          TextButton(
            onPressed: () {
              print('See all user recipes');
            },
            child: const Text(
              'see all',
              style: TextStyle(color: Color.fromARGB(255, 67, 47, 21)),
            ),
          ),
      ],
    );
  }
}
