import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

/// The user's own most-recently-added recipes, whether public or private —
/// so a recipe you just saved is easy to find right away, with a badge
/// making its visibility obvious at a glance.
class RecentlyAddedSection extends ConsumerWidget {
  const RecentlyAddedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRecipes = ref.watch(userRecipesProvider);

    if (userRecipes.isEmpty) return const SizedBox.shrink();

    final recent = userRecipes.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recently Added', style: AppText.serif(fontSize: 21)),
        SizedBox(
          height: 215,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final recipe = recent[index];
              return SizedBox(
                width: kRecipeCardWidth,
                child: RecipeCard(
                  recipe: recipe,
                  heroTag: 'profile_recent_${recipe.id}',
                  showVisibilityBadge: true,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemCount: recent.length,
          ),
        ),
      ],
    );
  }
}
