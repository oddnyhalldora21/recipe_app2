import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';
import 'package:recipe_app/shared/app_theme.dart';

class SurpriseMe extends ConsumerWidget {
  const SurpriseMe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final randomRecipes = RecipeService.getRandomRecipes(3);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recipe = randomRecipes[index];
            return _buildRecipeCard(context, recipe, theme);
          },
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemCount: randomRecipes.length,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, recipe, ThemeData theme) {
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
              child: Hero(
                tag: 'recommended_${recipe.id}',
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: AppShadows.card,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
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
                              color: const Color.fromARGB(255, 241, 181, 212),
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
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: AppShadows.soft,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 12,
                                  color: AppColors.brown,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  recipe.cookingTime,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.brown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
