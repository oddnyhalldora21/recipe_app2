import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'dart:math';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';
import 'package:recipe_app/features/recipe_ingredients/class_recipes.dart';

class AllRecipes extends ConsumerWidget {
  const AllRecipes({super.key});

  List<Recipe> getRandomRecipes(int count) {
    List<Recipe> allRecipes = [];

    allRecipes.addAll(ChocolateRecipes.getAllChocolateRecipes());
    allRecipes.addAll(PuffPastryRecipes.getAllPuffPastryRecipes());
    allRecipes.addAll(VeganRecipes.getAllVeganRecipes());
    allRecipes.addAll(CookieRecipes.getAllCookieRecipes());
    allRecipes.addAll(FrozenTreatsRecipes.getAllFrozenTreatsRecipes());
    allRecipes.addAll(GlutenFreeRecipes.getAllGlutenFreeRecipes());
    allRecipes.addAll(NoBakeRecipes.getAllNoBakeRecipes());
    allRecipes.addAll(SugarFreeRecipes.getAllSugarFreeRecipes());

    allRecipes.shuffle(Random());
    return allRecipes.take(count).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final randomRecipes = getRandomRecipes(10);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recipe = randomRecipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(recipe: recipe),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'recommended_${recipe.id}',
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            width: double.infinity,
                            child: Image.network(
                              recipe.imageUrl,
                              fit: BoxFit.cover,
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
                                  color: const Color.fromARGB(
                                    255,
                                    241,
                                    181,
                                    212,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.cake,
                                      size: 40,
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
                          ),
                        ),
                      ),
                    ),
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color.fromARGB(255, 67, 47, 21),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemCount: randomRecipes.length,
        ),
      ),
    );
  }
}
