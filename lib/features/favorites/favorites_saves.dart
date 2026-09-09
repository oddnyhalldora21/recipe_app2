import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';

class FavoritesSaves extends StateNotifier<List<Recipe>> {
  FavoritesSaves() : super([]) {
    loadFavorites();
    _authSubscription = _client.auth.onAuthStateChange.listen((_) {
      loadFavorites();
    });
  }

  static const String _table = 'favorites_sweettreats';
  SupabaseClient get _client => Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> loadFavorites() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      state = [];
      return;
    }

    try {
      final rows = await _client
          .from(_table)
          .select('recipe_id')
          .eq('user_id', userId);

      final favoriteIds =
          (rows as List).map((row) => row['recipe_id'] as String).toSet();

      final allRecipes = RecipeService.getAllRecipes();
      state =
          allRecipes
              .where((recipe) => favoriteIds.contains(recipe.id))
              .toList();
    } catch (e) {
      print('Error loading favorites: $e');
      state = [];
    }
  }

  Future<void> addToFavorites(Recipe recipe) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || isFavorited(recipe.id)) return;

    try {
      state = [...state, recipe];
      await _client.from(_table).insert({
        'user_id': userId,
        'recipe_id': recipe.id,
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      state = state.where((r) => r.id != recipe.id).toList();
    }
  }

  Future<void> removeFromFavorites(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final previousState = state;
    try {
      state = state.where((recipe) => recipe.id != recipeId).toList();
      await _client
          .from(_table)
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipeId);
    } catch (e) {
      print('Error removing from favorites: $e');
      state = previousState;
    }
  }

  bool isFavorited(String recipeId) {
    return state.any((recipe) => recipe.id == recipeId);
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    if (isFavorited(recipe.id)) {
      await removeFromFavorites(recipe.id);
    } else {
      await addToFavorites(recipe);
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesSaves, List<Recipe>>((
  ref,
) {
  return FavoritesSaves();
});
