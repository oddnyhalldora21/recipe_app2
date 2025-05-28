import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';
import 'package:recipe_app/features/widgets/recipes_search_bar.dart';
import 'package:recipe_app/features/home_page_widgets/home_app_bar.dart';
import 'package:recipe_app/features/home_page_widgets/categories_section.dart';
import 'package:recipe_app/features/home_page_widgets/surprise_me_section.dart';
import 'package:recipe_app/features/home_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/home_page_widgets/all_recipes_section.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: const HomeAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          RecipesSearchBar(
            onRecipeSelected: (recipe) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(recipe: recipe),
                ),
              );
            },
          ),

          // Categories Section
          const CategoriesSection(),

          // Surprise Me Section
          const SurpriseMeSection(),

          // My Recipes Section
          const MyRecipesSection(),

          // All Recipes Section
          const AllRecipesSection(),
        ],
      ),
    );
  }
}
