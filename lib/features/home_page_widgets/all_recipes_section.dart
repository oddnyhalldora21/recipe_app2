import 'package:flutter/material.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_page.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';

class AllRecipesSection extends StatelessWidget {
  const AllRecipesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "All Recipes",
          buttonText: "see all",
          onButtonPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllRecipesPage()),
            );
          },
        ),
        const AllRecipes(),
      ],
    );
  }
}
