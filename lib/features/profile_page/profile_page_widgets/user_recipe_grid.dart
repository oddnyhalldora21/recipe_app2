import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';

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
        border: Border.all(
          color: const Color.fromARGB(255, 241, 181, 212),
          width: 2,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 60,
              color: Color.fromARGB(255, 67, 47, 21),
            ),
            SizedBox(height: 16),
            Text(
              'No recipes yet!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 67, 47, 21),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create your first sweet treat recipe',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 67, 47, 21),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeGridView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemCount: userRecipes.length > 6 ? 6 : userRecipes.length,
      itemBuilder: (context, index) {
        final recipe = userRecipes[index];
        return _buildUserRecipeCard(recipe, context);
      },
    );
  }

  Widget _buildUserRecipeCard(Recipe recipe, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipe: recipe),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 241, 181, 212),
                                Color.fromARGB(255, 248, 187, 208),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.cake,
                              size: 50,
                              color: Color.fromARGB(255, 67, 47, 21),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        67,
                        47,
                        21,
                      ).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'MINE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 16,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    recipe.cookingTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
