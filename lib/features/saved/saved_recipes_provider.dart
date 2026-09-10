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

/// Where and when a saved recipe was filed. [collectionId] is an optional
/// organizational tag — a recipe with a collection is still part of
/// "All Saved", not moved out of it.
class SavedEntry {
  const SavedEntry({required this.collectionId, required this.savedAt});

  final String? collectionId;
  final DateTime savedAt;
}

class SavedRecipesState {
  const SavedRecipesState({
    this.entriesByRecipeId = const {},
    this.collections = const [],
  });

  final Map<String, SavedEntry> entriesByRecipeId;
  final List<RecipeCollection> collections;

  bool isSaved(String recipeId) => entriesByRecipeId.containsKey(recipeId);
  String? collectionIdFor(String recipeId) =>
      entriesByRecipeId[recipeId]?.collectionId;

  SavedRecipesState copyWith({
    Map<String, SavedEntry>? entriesByRecipeId,
    List<RecipeCollection>? collections,
  }) {
    return SavedRecipesState(
      entriesByRecipeId: entriesByRecipeId ?? this.entriesByRecipeId,
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
          .select('recipe_id, collection_id, created_at')
          .eq('user_id', userId);

      final collectionRows = await _client
          .from(_collectionsTable)
          .select('id, name')
          .eq('user_id', userId)
          .order('name');

      final entries = <String, SavedEntry>{
        for (final row in (savedRows as List))
          row['recipe_id'] as String: SavedEntry(
            collectionId: row['collection_id'] as String?,
            savedAt: DateTime.parse(row['created_at'] as String),
          ),
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
        entriesByRecipeId: entries,
        collections: collections,
      );
    } catch (e) {
      print('Error loading saved recipes: $e');
    }
  }

  /// Saves [recipe] with no collection tag, moving it out of any collection
  /// it was previously filed under. It stays part of "All Saved" either
  /// way. Returns whether it succeeded.
  Future<bool> saveToAllSaved(Recipe recipe) => _saveTo(recipe, null);

  /// Tags [recipe] with [collectionId] — it remains part of "All Saved" too.
  /// Returns whether it succeeded.
  Future<bool> saveToCollection(Recipe recipe, String collectionId) =>
      _saveTo(recipe, collectionId);

  Future<bool> _saveTo(Recipe recipe, String? collectionId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final previous = Map<String, SavedEntry>.from(state.entriesByRecipeId);
    final previousSavedAt = previous[recipe.id]?.savedAt ?? DateTime.now();
    state = state.copyWith(
      entriesByRecipeId: {
        ...previous,
        recipe.id: SavedEntry(
          collectionId: collectionId,
          savedAt: previousSavedAt,
        ),
      },
    );

    try {
      // A recipe has exactly one row (and one collection tag) at a time, so
      // clear any existing save before filing it under the new tag.
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
      return true;
    } catch (e) {
      print('Error saving recipe: $e');
      state = state.copyWith(entriesByRecipeId: previous);
      return false;
    }
  }

  Future<bool> removeFromSaved(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final previous = Map<String, SavedEntry>.from(state.entriesByRecipeId);
    final updated = Map<String, SavedEntry>.from(previous)..remove(recipeId);
    state = state.copyWith(entriesByRecipeId: updated);

    try {
      await _client
          .from(_savedTable)
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', recipeId);
      return true;
    } catch (e) {
      print('Error removing saved recipe: $e');
      state = state.copyWith(entriesByRecipeId: previous);
      return false;
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

/// Resolves the recipes saved to a given destination, most-recently-saved
/// first. Pass null for "All Saved" — every saved recipe, whether or not
/// it also has a collection tag — or a collection id to see just that
/// collection's recipes. [catalog] is the already-loaded recipe list (from
/// recipesCatalogProvider); this stays a plain sync function so it can run
/// straight from a widget build.
List<Recipe> recipesForLocation(
  SavedRecipesState state,
  String? collectionId,
  List<Recipe> catalog,
) {
  final matching =
      state.entriesByRecipeId.entries
          .where(
            (entry) =>
                collectionId == null ||
                entry.value.collectionId == collectionId,
          )
          .toList()
        ..sort((a, b) => b.value.savedAt.compareTo(a.value.savedAt));

  final byId = {for (final r in catalog) r.id: r};
  return [
    for (final entry in matching)
      if (byId[entry.key] != null) byId[entry.key]!,
  ];
}
