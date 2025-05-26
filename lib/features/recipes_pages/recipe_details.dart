import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/widgets/cooking_time_card.dart';
import 'package:recipe_app/features/widgets/ingredients_section.dart';
import 'package:recipe_app/features/widgets/instructions_section.dart';
import 'package:recipe_app/features/widgets/recipe_image_frame.dart';

class RecipeDetailsPage extends ConsumerWidget {
  const RecipeDetailsPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: _buildAppBar(context, ref),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Recipe Image with cute frame
            ImageFrame(imageUrl: recipe.imageUrl),

            // Cooking time card
            CookingTimeCard(cookingTime: recipe.cookingTime),

            // Ingredients section
            IngredientsSection(ingredients: recipe.ingredients),

            // Instructions section
            InstructionsSection(instructions: recipe.instructions),

            const SizedBox(height: 40), // Extra space at bottom
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      title: Text(
        recipe.name,
        style: const TextStyle(
          color: Color.fromARGB(255, 67, 47, 21),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final isFavorited = ref
                .watch(favoritesProvider.notifier)
                .isFavorited(recipe.id);

            return Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  255,
                  248,
                  231,
                ).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(recipe);
                },
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color:
                      isFavorited
                          ? const Color.fromARGB(
                            255,
                            139,
                            69,
                            19,
                          ) // Darker brown when favorited
                          : const Color.fromARGB(
                            255,
                            67,
                            47,
                            21,
                          ), // Regular brown when not favorited
                ),
              ),
            );
          },
        ),
      ],
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 67, 47, 21)),
    );
  }
}
