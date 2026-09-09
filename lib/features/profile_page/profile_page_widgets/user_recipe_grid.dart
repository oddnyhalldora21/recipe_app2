import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

class UserRecipesGrid extends StatelessWidget {
  final List<Recipe> userRecipes;

  const UserRecipesGrid({super.key, required this.userRecipes});

  @override
  Widget build(BuildContext context) {
    if (userRecipes.isEmpty) {
      return _buildEmptyState();
    }

    return _buildRecipeGridView(context);
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 60, color: AppColors.brown),
            SizedBox(height: 16),
            Text(
              'No recipes yet!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.brown,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create your first sweet treat recipe',
              style: TextStyle(fontSize: 14, color: AppColors.brown),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeGridView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: recipeGridColumns(constraints.maxWidth),
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.68,
          ),
          itemCount: userRecipes.length > 6 ? 6 : userRecipes.length,
          itemBuilder: (context, index) {
            final recipe = userRecipes[index];
            return RecipeCard(
              recipe: recipe,
              heroTag: 'profile_mine_${recipe.id}',
              showMineBadge: true,
            );
          },
        );
      },
    );
  }
}
