import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

/// Dedicated search screen: a search field at the top, live results below
/// as a scrollable grid of [RecipeCard]s — replaces the old floating
/// dropdown suggestions on Home.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Unchanged from the old RecipesSearchBar — matches recipe name,
  /// ingredients, or category (case-insensitive substring match).
  List<Recipe> _filterRecipes(List<Recipe> catalog, String query) {
    final lowercaseQuery = query.toLowerCase();

    return catalog.where((recipe) {
      final nameMatch = recipe.name.toLowerCase().contains(lowercaseQuery);

      final ingredientsMatch = recipe.ingredients.any(
        (ingredient) => ingredient.toLowerCase().contains(lowercaseQuery),
      );

      final categoryMatch = recipe.category.toLowerCase().contains(
        lowercaseQuery,
      );

      return nameMatch || ingredientsMatch || categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(recipesCatalogProvider).valueOrNull ?? const [];
    final hasQuery = _query.isNotEmpty;
    final results =
        hasQuery ? _filterRecipes(catalog, _query) : const <Recipe>[];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: AppShadows.card,
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value),
                  style: const TextStyle(color: AppColors.brown),
                  decoration: InputDecoration(
                    hintText: 'what are we craving?',
                    hintStyle: TextStyle(
                      color: AppColors.brown.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.pinkDeep,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    !hasQuery
                        ? _buildPrompt()
                        : results.isEmpty
                        ? _buildNoResults()
                        : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: kRecipeCardWidth,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.68,
                              ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final recipe = results[index];
                            return RecipeCard(
                              recipe: recipe,
                              heroTag: 'search_${recipe.id}',
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: AppColors.brown.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Search by name, ingredient, or category',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.brown.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: AppColors.brown.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'No recipes found for "$_query"',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.brown.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
