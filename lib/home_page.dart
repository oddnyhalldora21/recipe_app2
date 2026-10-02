import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/home_page_widgets/home_hero.dart';
import 'package:recipe_app/features/home_page_widgets/categories_section.dart';
import 'package:recipe_app/features/home_page_widgets/recently_added_section.dart';
import 'package:recipe_app/features/home_page_widgets/surprise_me_section.dart';
import 'package:recipe_app/features/home_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/home_page_widgets/all_recipes_section.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

class RecipePage extends ConsumerWidget {
  const RecipePage({super.key, this.onProfileTap});

  final VoidCallback? onProfileTap;

  /// Pull-to-refresh: re-fetches the shared catalog (Categories, Recently
  /// Added, Surprise Me, All Recipes) and the user's own recipes (My
  /// Recipes) together. On failure the sections keep their last data.
  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    try {
      await Future.wait([
        ref.refresh(recipesCatalogProvider.future),
        ref.read(userRecipesProvider.notifier).refresh(),
      ]);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't refresh — check your connection."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        color: AppColors.pinkDeep,
        backgroundColor: Colors.white,
        onRefresh: () => _refresh(context, ref),
        child: ListView(
          primary: true,
          // Pull-down works even if Home is ever shorter than the screen.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const HomeHero(),

            Padding(
              // No top padding: the first SectionHeader's own top spacing
              // is enough below the hero headline.
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Categories Section
                  const CategoriesSection(),

                  // Recently Added Section
                  const RecentlyAddedSection(),

                  // Surprise Me Section
                  const SurpriseMeSection(),

                  // My Recipes Section
                  MyRecipesSection(onSeeAllTap: onProfileTap),

                  // All Recipes Section
                  const AllRecipesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
