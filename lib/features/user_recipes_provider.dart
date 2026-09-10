import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

/// The signed-in user's own recipes, stored in recipes_sweettreats under
/// their own user_id. Each recipe is private by default; the user can opt
/// in to making one public from Add Recipe, which then also surfaces it in
/// the shared All Recipes catalog.
class UserRecipesNotifier extends StateNotifier<List<Recipe>> {
  UserRecipesNotifier() : super([]) {
    _load();
    _authSubscription = _client.auth.onAuthStateChange.listen((_) => _load());
  }

  SupabaseClient get _client => Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      state = [];
      return;
    }

    try {
      final rows = await _client
          .from(RecipeService.table)
          .select(
            'id, name, ingredients, steps, category, image_url, user_id, is_public, created_at',
          )
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      state = (rows as List).map(RecipeService.fromRow).toList();
    } catch (e) {
      print('Error loading your recipes: $e');
      state = [];
    }
  }

  /// Adds a recipe under the current user. [isPublic] defaults to false so
  /// recipes are private unless the user opts in to sharing them. Returns
  /// whether it succeeded.
  Future<bool> addRecipe({
    required String name,
    required String imageUrl,
    required List<String> ingredients,
    required List<String> instructions,
    required String category,
    bool isPublic = false,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final row =
          await _client
              .from(RecipeService.table)
              .insert({
                'user_id': userId,
                'name': name,
                'image_url': imageUrl,
                'ingredients': ingredients,
                'steps': RecipeService.toStepsText(instructions),
                'category': category,
                'is_public': isPublic,
              })
              .select()
              .single();

      state = [...state, RecipeService.fromRow(row)];
      return true;
    } catch (e) {
      print('Error adding recipe: $e');
      return false;
    }
  }

  Future<bool> removeRecipe(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final previous = state;
    state = state.where((recipe) => recipe.id != recipeId).toList();

    try {
      await _client
          .from(RecipeService.table)
          .delete()
          .eq('user_id', userId)
          .eq('id', recipeId);
      return true;
    } catch (e) {
      print('Error removing recipe: $e');
      state = previous;
      return false;
    }
  }
}

final userRecipesProvider =
    StateNotifierProvider<UserRecipesNotifier, List<Recipe>>((ref) {
      return UserRecipesNotifier();
    });
