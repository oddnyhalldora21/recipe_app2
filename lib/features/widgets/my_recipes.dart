import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';

class MyRecipesWidget extends ConsumerWidget {
  const MyRecipesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRecipes = ref.watch(userRecipesProvider);

    if (myRecipes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.pinkLight, width: 1),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 32, color: AppColors.brown),
                SizedBox(height: 8),
                Text(
                  'No recipes yet!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brown,
                  ),
                ),
                Text(
                  'Add your first recipe from your profile',
                  style: TextStyle(fontSize: 12, color: AppColors.brown),
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
        height: 215,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recipe = myRecipes[index];
            return SizedBox(
              width: 160,
              child: RecipeCard(
                recipe: recipe,
                heroTag: 'home_myrecipes_${recipe.id}',
                showMineBadge: true,
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemCount: myRecipes.length,
        ),
      ),
    );
  }
}
