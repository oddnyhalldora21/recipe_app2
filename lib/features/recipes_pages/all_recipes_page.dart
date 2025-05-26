import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'dart:math';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';

class AllRecipesPage extends ConsumerWidget {
  const AllRecipesPage({super.key});

  // Function to get ALL recipes from every category
  List<Recipe> getAllRecipes() {
    List<Recipe> allRecipes = [];

    // Add recipes from all categories
    allRecipes.addAll(ChocolateRecipes.getAllChocolateRecipes());
    allRecipes.addAll(VeganRecipes.getAllVeganRecipes());
    allRecipes.addAll(CookieRecipes.getAllCookieRecipes());
    allRecipes.addAll(SugarFreeRecipes.getAllSugarFreeRecipes());
    allRecipes.addAll(GlutenFreeRecipes.getAllGlutenFreeRecipes());
    allRecipes.addAll(FrozenTreatsRecipes.getAllFrozenTreatsRecipes());
    allRecipes.addAll(NoBakeRecipes.getAllNoBakeRecipes());
    allRecipes.addAll(PuffPastryRecipes.getAllPuffPastryRecipes());

    allRecipes.shuffle(Random());

    return allRecipes;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = getAllRecipes();

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        241,
        181,
        212,
      ), // Cream background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
          255,
          241,
          181,
          212,
        ), // Pink AppBar
        title: Text(
          'All Recipes',
          style: TextStyle(
            color: const Color.fromARGB(255, 67, 47, 21), // Chocolate brown
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(
            255,
            67,
            47,
            21,
          ), // Chocolate brown back arrow
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with recipe count
            Text(
              'Here we have ${allRecipes.length} Sweet Treats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 67, 47, 21),
              ),
            ),
            SizedBox(height: 16),

            // Grid of all recipes
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: allRecipes.length, // Show ALL recipes
                itemBuilder: (context, index) {
                  final recipe = allRecipes[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecipeDetailsPage(recipe: recipe),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe Image Card
                        Expanded(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  // Recipe Image
                                  Image.network(
                                    recipe.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: const Color.fromARGB(
                                          255,
                                          241,
                                          181,
                                          212,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: const Color.fromARGB(
                                              255,
                                              67,
                                              47,
                                              21,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              const Color.fromARGB(
                                                255,
                                                241,
                                                181,
                                                212,
                                              ),
                                              const Color.fromARGB(
                                                255,
                                                248,
                                                187,
                                                208,
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.cake,
                                            size: 50,
                                            color: const Color.fromARGB(
                                              255,
                                              67,
                                              47,
                                              21,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // Category Badge (optional - shows what category the recipe is from)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          67,
                                          47,
                                          21,
                                        ).withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        recipe.category.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        // Recipe Name and Cooking Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Recipe name
                            Expanded(
                              child: Text(
                                recipe.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 67, 47, 21),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),

                            // Cooking time
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: const Color.fromARGB(255, 67, 47, 21),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  recipe.cookingTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color.fromARGB(
                                      255,
                                      67,
                                      47,
                                      21,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
