import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';

/// The newest public recipes across every user, most-recently-added first —
/// lets people (including whoever just published one) see fresh recipes
/// land in the shared catalog.
class RecentlyAdded extends ConsumerWidget {
  const RecentlyAdded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(recipesCatalogProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 215,
        child: catalog.when(
          data: (recipes) {
            final sorted = [...recipes]..sort((a, b) {
              final aTime = a.createdAt;
              final bTime = b.createdAt;
              if (aTime == null && bTime == null) return 0;
              if (aTime == null) return 1;
              if (bTime == null) return -1;
              return bTime.compareTo(aTime);
            });
            final recent = sorted.take(10).toList();

            if (recent.isEmpty) {
              return const Center(
                child: Text(
                  'No public recipes yet.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              );
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final recipe = recent[index];
                return SizedBox(
                  width: kRecipeCardWidth,
                  child: RecipeCard(
                    recipe: recipe,
                    heroTag: 'recent_${recipe.id}',
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemCount: recent.length,
            );
          },
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: AppColors.pinkDeep),
              ),
          error:
              (error, stackTrace) => Center(
                child: Text(
                  'Could not load recipes.',
                  style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                ),
              ),
        ),
      ),
    );
  }
}
