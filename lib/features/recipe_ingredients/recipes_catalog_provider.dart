import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

/// The full recipe catalog, fetched once from recipes_sweettreats and
/// cached for the app's lifetime. Screens `ref.watch` this and slice the
/// resolved list (shuffle, filter by category, etc.) themselves.
final recipesCatalogProvider = FutureProvider<List<Recipe>>((ref) {
  return RecipeService.getAllRecipes();
});
