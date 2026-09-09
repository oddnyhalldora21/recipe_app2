import 'package:flutter/material.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class MyRecipesSection extends StatelessWidget {
  final List<Recipe> userRecipes;

  const MyRecipesSection({super.key, required this.userRecipes});

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: 'My Recipes (${userRecipes.length})',
      buttonText: userRecipes.isNotEmpty ? 'see all' : null,
      onButtonPressed:
          userRecipes.isNotEmpty
              ? () {
                print('See all user recipes');
              }
              : null,
    );
  }
}
