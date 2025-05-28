import 'dart:math';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class RecipeService {
  static List<Recipe> getAllRecipes() {
    List<Recipe> allRecipes = [];

    allRecipes.addAll(ChocolateRecipes.getAllChocolateRecipes());
    allRecipes.addAll(VeganRecipes.getAllVeganRecipes());
    allRecipes.addAll(CookieRecipes.getAllCookieRecipes());
    allRecipes.addAll(SugarFreeRecipes.getAllSugarFreeRecipes());
    allRecipes.addAll(GlutenFreeRecipes.getAllGlutenFreeRecipes());
    allRecipes.addAll(FrozenTreatsRecipes.getAllFrozenTreatsRecipes());
    allRecipes.addAll(NoBakeRecipes.getAllNoBakeRecipes());
    allRecipes.addAll(PuffPastryRecipes.getAllPuffPastryRecipes());

    return allRecipes;
  }

  static List<Recipe> getShuffledRecipes() {
    List<Recipe> recipes = getAllRecipes();
    recipes.shuffle(Random());
    return recipes;
  }

  // Function to get random recipes for "Surprise Me"
  static List<Recipe> getRandomRecipes(int count) {
    List<Recipe> allRecipes = getAllRecipes();
    allRecipes.shuffle(Random());
    return allRecipes.take(count).toList();
  }
}
