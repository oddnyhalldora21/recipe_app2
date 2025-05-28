import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/profile_page/dummy_user_recipes.dart';

class UserRecipesNotifier extends StateNotifier<List<Recipe>> {
  UserRecipesNotifier() : super(DummyUserRecipes.getDummyRecipes());

  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
  }

  void removeRecipe(String recipeId) {
    state = state.where((recipe) => recipe.id != recipeId).toList();
  }

  void updateRecipe(Recipe updatedRecipe) {
    state =
        state.map((recipe) {
          if (recipe.id == updatedRecipe.id) {
            return updatedRecipe;
          }
          return recipe;
        }).toList();
  }

  void clearAllRecipes() {
    state = [];
  }
}

final userRecipesProvider =
    StateNotifierProvider<UserRecipesNotifier, List<Recipe>>((ref) {
      return UserRecipesNotifier();
    });
