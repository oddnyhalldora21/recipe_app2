import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

/// The Profile recipe grid as a sliver, so it builds cards lazily as they
/// scroll into view; the empty state is a plain box adapter.
class UserRecipesGrid extends StatelessWidget {
  final List<Recipe> userRecipes;

  /// Empty-state wording, so a filtered tab can say e.g. "No private
  /// recipes yet" instead of the overall "No recipes yet".
  final String emptyTitle;
  final String emptyMessage;

  const UserRecipesGrid({
    super.key,
    required this.userRecipes,
    this.emptyTitle = 'No recipes yet',
    this.emptyMessage = 'Add your first recipe to see it here.',
  });

  @override
  Widget build(BuildContext context) {
    if (userRecipes.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState());
    }

    return _buildRecipeGrid(context);
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.pink, width: 2),
        boxShadow: AppShadows.soft,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.restaurant_menu,
                size: 60,
                color: AppColors.brown,
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emptyMessage,
                style: const TextStyle(fontSize: 14, color: AppColors.brown),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeGrid(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: kRecipeCardWidth,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.68,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final recipe = userRecipes[index];
        return RecipeCard(
          recipe: recipe,
          heroTag: 'profile_mine_${recipe.id}',
          showVisibilityBadge: true,
        );
      }, childCount: userRecipes.length),
    );
  }
}
