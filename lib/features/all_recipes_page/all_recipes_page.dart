import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes_header.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/all_recipes_grid.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';

class AllRecipesPage extends ConsumerWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = RecipeService.getShuffledRecipes();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        title: const Text(
          'All Recipes',
          style: TextStyle(
            color: Color.fromARGB(255, 67, 47, 21),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 67, 47, 21)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AllRecipesHeader(allRecipes: allRecipes),
            const SizedBox(height: 16),

            Expanded(child: AllRecipesGrid(allRecipes: allRecipes)),
          ],
        ),
      ),
    );
  }
}
