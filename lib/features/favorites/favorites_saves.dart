// File: lib/features/favorites/favorites_saves.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

// Simple favorites provider using SharedPreferences
class FavoritesSaves extends StateNotifier<List<Recipe>> {
  FavoritesSaves() : super([]) {
    loadFavorites();
  }

  static const String _favoritesKey = 'favorite_recipes';

  // Load favorites from storage
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];

      // Get all recipes from all categories
      List<Recipe> allRecipes = [];
      allRecipes.addAll(ChocolateRecipes.getAllChocolateRecipes());
      allRecipes.addAll(VeganRecipes.getAllVeganRecipes());
      allRecipes.addAll(CookieRecipes.getAllCookieRecipes());
      allRecipes.addAll(SugarFreeRecipes.getAllSugarFreeRecipes());
      allRecipes.addAll(NoBakeRecipes.getAllNoBakeRecipes());
      allRecipes.addAll(PuffPastryRecipes.getAllPuffPastryRecipes());
      allRecipes.addAll(GlutenFreeRecipes.getAllGlutenFreeRecipes());

      // Filter recipes that are in favorites
      final favoriteRecipes =
          allRecipes
              .where((recipe) => favoriteIds.contains(recipe.id))
              .toList();

      state = favoriteRecipes;
    } catch (e) {
      print('Error loading favorites: $e');
      state = [];
    }
  }

  // Add recipe to favorites
  Future<void> addToFavorites(Recipe recipe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];

      if (!favoriteIds.contains(recipe.id)) {
        favoriteIds.add(recipe.id);
        await prefs.setStringList(_favoritesKey, favoriteIds);
        state = [...state, recipe];
      }
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  // Remove recipe from favorites
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];

      favoriteIds.remove(recipeId);
      await prefs.setStringList(_favoritesKey, favoriteIds);
      state = state.where((recipe) => recipe.id != recipeId).toList();
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  // Check if recipe is favorited
  bool isFavorited(String recipeId) {
    return state.any((recipe) => recipe.id == recipeId);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Recipe recipe) async {
    if (isFavorited(recipe.id)) {
      await removeFromFavorites(recipe.id);
    } else {
      await addToFavorites(recipe);
    }
  }
}

// Provider for the favorites
final favoritesProvider = StateNotifierProvider<FavoritesSaves, List<Recipe>>((
  ref,
) {
  return FavoritesSaves();
});
