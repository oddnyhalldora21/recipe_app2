import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

/// A user-created named collection (e.g. "Make Later", "Cookies").
class RecipeCollection {
  const RecipeCollection({required this.id, required this.name});

  final String id;
  final String name;
}

class SavedRecipesState {
  const SavedRecipesState({
    this.locationByRecipeId = const {},
    this.collections = const [],
  });

  /// recipeId -> collectionId. A null value means the recipe is saved to
  /// "All Saved" rather than a specific named collection. A recipe not
  /// present in this map isn't saved at all.
  final Map<String, String?> locationByRecipeId;
  final List<RecipeCollection> collections;

  bool isSaved(String recipeId) => locationByRecipeId.containsKey(recipeId);
  String? collectionIdFor(String recipeId) => locationByRecipeId[recipeId];

  SavedRecipesState copyWith({
    Map<String, String?>? locationByRecipeId,
    List<RecipeCollection>? collections,
  }) {
    return SavedRecipesState(
      locationByRecipeId: locationByRecipeId ?? this.locationByRecipeId,
      collections: collections ?? this.collections,
    );
  }
}

class SavedRecipesNotifier extends StateNotifier<SavedRecipesState> {
  SavedRecipesNotifier() : super(const SavedRecipesState()) {
    _load();
    _authSubscription = _client.auth.onAuthStateChange.listen((_) => _load());
  }

  static const String _savedTable = 'saved_recipes_sweettreats';
  static const String _collectionsTable = 'collections_sweettreats';

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
      state = const SavedRecipesState();
      return;
    }

    try {
      final savedRows = await _client
          .from(_savedTable)
          .select('recipe_id, collection_id')
          .eq('user_id', userId);

      final collectionRows = await _client
          .from(_collectionsTable)
          .select('id, name')
          .eq('user_id', userId)
          .order('name');

      final locations = <String, String?>{
        for (final row in (savedRows as List))
          row['recipe_id'] as String: row['collection_id'] as String?,
      };

      final collections =
          (collectionRows as List)
              .map(
                (row) => RecipeCollection(
                  id: row['id'] as String,
                  name: row['name'] as String,
                ),
              )
              .toList();

      state = SavedRecipesState(
        locationByRecipeId: locations,
        collections: collections,
      );
    } catch (e) {
      print('Error loading saved recipes: $e');
    }
  }

  /// Saves [recipe] to "All Saved" (no collection), moving it there if it
  /// was previously filed under a collection.
  Future<void> saveToAllSaved(Recipe recipe) => _saveTo(recipe, null);

  /// Saves [recipe] into [collectionId], moving it there if already saved
  /// elsewhere.
  Future<void> saveToCollection(Recipe recipe, String collectionId) =>
      _saveTo(recipe, collectionId);

  Future<void> _saveTo(Recipe recipe, String? collectionId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final previous = Map<String, String?>.from(state.locationByRecipeId);
    state = state.copyWith(
      locationByRecipeId: {...previous, recipe.id: collectionId},
    );

    try {
      // A recipe lives in exactly one place at a time, so clear any
      // existing save before filing it under the new destination.
      await _client
          .from(_savedTable)
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipe.id);
      await _client.from(_savedTable).insert({
        'user_id': userId,
        'recipe_id': recipe.id,
        'collection_id': collectionId,
      });
    } catch (e) {
      print('Error saving recipe: $e');
      state = state.copyWith(locationByRecipeId: previous);
    }
  }

  Future<void> removeFromSaved(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final previous = Map<String, String?>.from(state.locationByRecipeId);
    final updated = Map<String, String?>.from(previous)..remove(recipeId);
    state = state.copyWith(locationByRecipeId: updated);

    try {
      await _client
          .from(_savedTable)
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipeId);
    } catch (e) {
      print('Error removing saved recipe: $e');
      state = state.copyWith(locationByRecipeId: previous);
    }
  }

  /// Creates a new named collection and returns it, or null on failure.
  Future<RecipeCollection?> createCollection(String name) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final row =
          await _client
              .from(_collectionsTable)
              .insert({'user_id': userId, 'name': name})
              .select()
              .single();
      final collection = RecipeCollection(
        id: row['id'] as String,
        name: row['name'] as String,
      );
      state = state.copyWith(collections: [...state.collections, collection]);
      return collection;
    } catch (e) {
      print('Error creating collection: $e');
      return null;
    }
  }
}

final savedRecipesProvider =
    StateNotifierProvider<SavedRecipesNotifier, SavedRecipesState>((ref) {
      return SavedRecipesNotifier();
    });
