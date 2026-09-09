import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes_header.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes_grid.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/shared/app_theme.dart';

class AllRecipesPage extends ConsumerWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = RecipeService.getShuffledRecipes();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Recipes', style: AppText.serif(fontSize: 26)),
            const SizedBox(height: 4),
            AllRecipesHeader(allRecipes: allRecipes),
            const SizedBox(height: 16),

            Expanded(child: AllRecipesGrid(allRecipes: allRecipes)),
          ],
        ),
      ),
    );
  }
}
