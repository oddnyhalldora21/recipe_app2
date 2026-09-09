import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/shared/app_theme.dart';

class RecipesSearchBar extends StatelessWidget {
  const RecipesSearchBar({super.key, this.onRecipeSelected});

  final Function(Recipe)? onRecipeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppShadows.card,
      ),
      child: SearchAnchor.bar(
        barHintText: "what are we craving?",
        barElevation: const WidgetStatePropertyAll(0),
        barSide: const WidgetStatePropertyAll(BorderSide.none),
        viewBackgroundColor: theme.colorScheme.surfaceContainerLowest,
        barBackgroundColor: const WidgetStatePropertyAll(Colors.white),
        barHintStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.brown.withOpacity(0.5)),
        ),
        barTextStyle: const WidgetStatePropertyAll(
          TextStyle(color: AppColors.brown),
        ),
        barLeading: const Icon(Icons.search, color: AppColors.pinkDeep),
        suggestionsBuilder: (context, controller) {
          // If search is empty, show popular suggestions
          if (controller.text.isEmpty) {
            return _buildEmptySearchSuggestions(context);
          }

          // Filter recipes based on search query
          final filteredRecipes = _filterRecipes(controller.text);

          return filteredRecipes
              .map((recipe) => _buildRecipeTile(context, recipe, controller))
              .toList();
        },
      ),
    );
  }

  List<Recipe> _getAllRecipes() {
    List<Recipe> allRecipes = [];

    // Add recipes from all categories
    allRecipes.addAll(ChocolateRecipes.getAllChocolateRecipes());
    allRecipes.addAll(VeganRecipes.getAllVeganRecipes());
    allRecipes.addAll(CookieRecipes.getAllCookieRecipes());
    allRecipes.addAll(SugarFreeRecipes.getAllSugarFreeRecipes());
    allRecipes.addAll(GlutenFreeRecipes.getAllGlutenFreeRecipes());
    allRecipes.addAll(FrozenTreatsRecipes.getAllFrozenTreatsRecipes());
    allRecipes.addAll(NoBakeRecipes.getAllNoBakeRecipes());
    allRecipes.addAll(PuffPastryRecipes.getAllPuffPastryRecipes());

    return allRecipes;
  }

  List<Recipe> _filterRecipes(String query) {
    final lowercaseQuery = query.toLowerCase();
    final allRecipes = _getAllRecipes();

    return allRecipes.where((recipe) {
      // Search in recipe name
      final nameMatch = recipe.name.toLowerCase().contains(lowercaseQuery);

      // Search in ingredients
      final ingredientsMatch = recipe.ingredients.any(
        (ingredient) => ingredient.toLowerCase().contains(lowercaseQuery),
      );

      // Search in cooking time
      final timeMatch = recipe.cookingTime.toLowerCase().contains(
        lowercaseQuery,
      );

      // Search in category
      final categoryMatch = recipe.category.toLowerCase().contains(
        lowercaseQuery,
      );

      return nameMatch || ingredientsMatch || timeMatch || categoryMatch;
    }).toList();
  }

  List<Widget> _buildEmptySearchSuggestions(BuildContext context) {
    // Show popular search terms
    final suggestions = ['maybe something with Chocolate?'];

    return suggestions
        .map(
          (suggestion) => ListTile(
            leading: const Icon(Icons.search, color: AppColors.brown),
            title: Text(
              suggestion,
              style: const TextStyle(color: AppColors.brown),
            ),
            onTap: () {
              // Close search when suggestion is tapped
              Navigator.of(context).pop();
            },
          ),
        )
        .toList();
  }

  Widget _buildRecipeTile(
    BuildContext context,
    Recipe recipe,
    SearchController controller,
  ) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.pink, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            recipe.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.cream,
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.brown,
                  size: 20,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: AppColors.cream,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brown,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        recipe.name,
        style: AppText.serif(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.timer, size: 14, color: AppColors.brown.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(
            recipe.cookingTime,
            style: TextStyle(
              color: AppColors.brown.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.pinkLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              recipe.category.toUpperCase(),
              style: const TextStyle(
                color: AppColors.brown,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.brown,
        size: 16,
      ),
      onTap: () {
        // Close search and navigate to recipe
        controller.closeView(recipe.name);
        onRecipeSelected?.call(recipe);
      },
    );
  }
}
