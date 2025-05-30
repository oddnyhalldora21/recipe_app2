import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';

class MyRecipesWidget extends ConsumerWidget {
  const MyRecipesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final myRecipes = ref.watch(userRecipesProvider);

    if (myRecipes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 67, 47, 21).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 32,
                  color: Color.fromARGB(255, 67, 47, 21),
                ),
                SizedBox(height: 8),
                Text(
                  'No recipes yet!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
                Text(
                  'Add your first recipe from your profile',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recipe = myRecipes[index];
            return _buildRecipeCard(context, recipe, theme);
          },
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemCount: myRecipes.length,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    Recipe recipe,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipe: recipe),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'my_recipe_${recipe.id}',
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 4),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: double.infinity,
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color.fromARGB(255, 241, 181, 212),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 67, 47, 21),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
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
                                  size: 40,
                                  color: Color.fromARGB(255, 67, 47, 21),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // "MINE" badge
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
            Text(
              recipe.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color.fromARGB(255, 67, 47, 21),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
