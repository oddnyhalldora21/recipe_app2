import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';

class SurpriseMe extends ConsumerWidget {
  const SurpriseMe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomRecipes = RecipeService.getRandomRecipes(3);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 215,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final recipe = randomRecipes[index];
            return SizedBox(
              width: 160,
              child: RecipeCard(
                recipe: recipe,
                heroTag: 'surprise_${recipe.id}',
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemCount: randomRecipes.length,
        ),
      ),
    );
  }
}
