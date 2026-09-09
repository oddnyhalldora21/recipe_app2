import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'dart:math';
import 'package:recipe_app/features/widgets/recipe_card.dart';

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
    final randomRecipes = getRandomRecipes(10);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 215,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recipe = randomRecipes[index];
            return SizedBox(
              width: 160,
              child: RecipeCard(
                recipe: recipe,
                heroTag: 'home_allrecipes_${recipe.id}',
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
