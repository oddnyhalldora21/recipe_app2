import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

// Provider for user-created recipes
final userRecipesProvider =
    StateNotifierProvider<UserRecipesNotifier, List<Recipe>>((ref) {
      return UserRecipesNotifier();
    });

class UserRecipesNotifier extends StateNotifier<List<Recipe>> {
  UserRecipesNotifier() : super([]) {
    loadRecipes(); // Load saved recipes when provider is created
  }

  // Add a new recipe
  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
    _saveRecipes();
  }

  // Remove a recipe by ID
  void removeRecipe(String id) {
    state = state.where((recipe) => recipe.id != id).toList();
    _saveRecipes();
  }

  // Update an existing recipe
  void updateRecipe(Recipe updatedRecipe) {
    state = [
      for (final recipe in state)
        if (recipe.id == updatedRecipe.id) updatedRecipe else recipe,
    ];
    _saveRecipes();
  }

  // Save recipes to device storage
  Future<void> _saveRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recipesJson = state.map((recipe) => _recipeToJson(recipe)).toList();
      await prefs.setString('user_recipes', json.encode(recipesJson));
    } catch (e) {
      print('Error saving recipes: $e');
    }
  }

  // Load recipes from device storage
  Future<void> loadRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recipesString = prefs.getString('user_recipes');
      if (recipesString != null) {
        final recipesList = json.decode(recipesString) as List;
        state = recipesList.map((json) => _recipeFromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading recipes: $e');
    }
  }

  // Convert Recipe to JSON (you might need to adjust based on your Recipe class)
  Map<String, dynamic> _recipeToJson(Recipe recipe) {
    return {
      'id': recipe.id,
      'name': recipe.name,
      'imageUrl': recipe.imageUrl,
      'cookingTime': recipe.cookingTime,
      'category': recipe.category,
      'ingredients': recipe.ingredients,
      'instructions': recipe.instructions,
    };
  }

  // Convert JSON to Recipe (you might need to adjust based on your Recipe class)
  Recipe _recipeFromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      cookingTime: json['cookingTime'],
      category: json['category'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
    );
  }
}
