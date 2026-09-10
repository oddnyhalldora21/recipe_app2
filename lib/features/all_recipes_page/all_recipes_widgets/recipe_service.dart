import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

/// Recipes now live in recipes_sweettreats (Supabase) rather than the old
/// static Dart catalog. This is the single place that fetches them; screens
/// get the cached list via recipesCatalogProvider and use the sync helpers
/// below (shuffle/randomRecipes) to slice it, instead of re-querying.
class RecipeService {
  static const String table = 'recipes_sweettreats';

  static Future<List<Recipe>> getAllRecipes() async {
    final rows = await Supabase.instance.client
        .from(table)
        .select(
          'id, name, ingredients, steps, category, image_url, user_id, is_public, created_at',
        )
        .eq('is_public', true);

    return (rows as List).map(fromRow).toList();
  }

  static Recipe fromRow(dynamic row) {
    final steps = row['steps'] as String? ?? '';
    // steps is stored as "1. ...\n2. ..." — recover the step list so
    // InstructionsSection can keep rendering numbered steps.
    final instructions =
        steps
            .split('\n')
            .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
            .where((line) => line.isNotEmpty)
            .toList();

    return Recipe(
      id: row['id'] as String,
      name: row['name'] as String,
      imageUrl: row['image_url'] as String? ?? '',
      ingredients: List<String>.from(row['ingredients'] as List? ?? const []),
      instructions: instructions,
      // recipes_sweettreats has no cooking-time column; UI hides the
      // time pill/badge wherever this is empty.
      cookingTime: '',
      category: row['category'] as String? ?? '',
      createdAt:
          row['created_at'] != null
              ? DateTime.parse(row['created_at'] as String)
              : null,
      isPublic: row['is_public'] as bool? ?? true,
      userId: row['user_id'] as String?,
    );
  }

  /// Reverse of the parsing in [fromRow] — joins steps into the numbered
  /// text block recipes_sweettreats stores in its single `steps` column.
  static String toStepsText(List<String> instructions) {
    return [
      for (var i = 0; i < instructions.length; i++)
        '${i + 1}. ${instructions[i]}',
    ].join('\n');
  }

  static List<Recipe> shuffle(List<Recipe> recipes) {
    final copy = List<Recipe>.from(recipes);
    copy.shuffle(Random());
    return copy;
  }

  static List<Recipe> randomRecipes(List<Recipe> recipes, int count) {
    return shuffle(recipes).take(count).toList();
  }
}
