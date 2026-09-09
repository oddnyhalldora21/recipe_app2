import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';
import 'package:recipe_app/features/home_page_widgets/home_hero.dart';
import 'package:recipe_app/features/home_page_widgets/categories_section.dart';
import 'package:recipe_app/features/home_page_widgets/surprise_me_section.dart';
import 'package:recipe_app/features/home_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/home_page_widgets/all_recipes_section.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, this.onProfileTap});

  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HomeHero(
            onRecipeSelected: (recipe) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(recipe: recipe),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Categories Section
                const CategoriesSection(),

                // Surprise Me Section
                const SurpriseMeSection(),

                // My Recipes Section
                MyRecipesSection(onSeeAllTap: onProfileTap),

                // All Recipes Section
                const AllRecipesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
