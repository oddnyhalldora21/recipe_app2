import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/all_recipes_page/all_recipes_widgets/recipe_service.dart';
import 'package:recipe_app/features/home_page_widgets/home_hero.dart';
import 'package:recipe_app/features/home_page_widgets/categories_section.dart';
import 'package:recipe_app/features/home_page_widgets/recently_added_section.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/features/home_page_widgets/surprise_me_section.dart';
import 'package:recipe_app/features/home_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/primary_button.dart';

class RecipePage extends ConsumerStatefulWidget {
  const RecipePage({super.key, this.onProfileTap});

  final VoidCallback? onProfileTap;

  @override
  ConsumerState<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends ConsumerState<RecipePage> {
  /// All Recipes shows this many at first, and this many more per
  /// "Load more" tap.
  static const int _pageSize = 30;

  int _visibleCount = _pageSize;

  /// The catalog list the current shuffle was made from, so All Recipes
  /// reshuffles only when the catalog itself changes (first load, pull-to-
  /// refresh) — not on every rebuild, which would scramble the grid on each
  /// "Load more" tap.
  List<Recipe>? _shuffledFrom;
  List<Recipe> _shuffled = const [];

  List<Recipe> _shuffledCatalog(List<Recipe> recipes) {
    if (!identical(recipes, _shuffledFrom)) {
      _shuffledFrom = recipes;
      _shuffled = RecipeService.shuffle(recipes);
    }
    return _shuffled;
  }

  /// Pull-to-refresh: re-fetches the shared catalog (Categories, Recently
  /// Added, Surprise Me, All Recipes) and the user's own recipes (My
  /// Recipes) together, then starts All Recipes over at the first page. On
  /// failure the sections keep their last data.
  Future<void> _refresh() async {
    try {
      await Future.wait([
        ref.refresh(recipesCatalogProvider.future),
        ref.read(userRecipesProvider.notifier).refresh(),
      ]);
      if (mounted) setState(() => _visibleCount = _pageSize);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't refresh — check your connection."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  /// The All Recipes grid plus its "Load more" button, or a placeholder
  /// while the catalog loads or if it fails.
  List<Widget> _allRecipesSlivers(AsyncValue<List<Recipe>> catalog) {
    Widget message(Widget child) => SliverToBoxAdapter(
      child: SizedBox(height: 215, child: Center(child: child)),
    );

    return catalog.when(
      // Keeps showing the last recipes if a pull-to-refresh fails.
      skipError: true,
      data: (catalogRecipes) {
        final recipes = _shuffledCatalog(catalogRecipes);
        final shownCount =
            _visibleCount < recipes.length ? _visibleCount : recipes.length;

        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            sliver: SliverGrid(
              // Same card proportions as the category pages.
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final recipe = recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  heroTag: 'home_allrecipes_${recipe.id}',
                );
              }, childCount: shownCount),
            ),
          ),
          if (shownCount < recipes.length)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: PrimaryButton(
                  onPressed: () => setState(() => _visibleCount += _pageSize),
                  child: const Text(
                    'Load more',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ];
      },
      loading:
          () => [
            message(const CircularProgressIndicator(color: AppColors.pinkDeep)),
          ],
      error:
          (error, stackTrace) => [
            message(
              Text(
                'Could not load recipes.',
                style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
              ),
            ),
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(recipesCatalogProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        color: AppColors.pinkDeep,
        backgroundColor: Colors.white,
        onRefresh: _refresh,
        child: CustomScrollView(
          primary: true,
          // Pull-down works even if Home is ever shorter than the screen.
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: HomeHero()),

            SliverPadding(
              // No top padding: the first SectionHeader's own top spacing
              // is enough below the hero headline.
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Surprise Me Section
                    const SurpriseMeSection(),

                    // Recently Added Section
                    const RecentlyAddedSection(),

                    // Categories Section
                    const CategoriesSection(),

                    // My Recipes Section
                    MyRecipesSection(onSeeAllTap: widget.onProfileTap),

                    // All Recipes Section — the grid below already lists
                    // every recipe, so there's no "see all" link. Without
                    // that button the title row is shorter, so the extra
                    // top padding keeps the gap above it matching the other
                    // sections'.
                    const SectionHeader(title: 'All Recipes', topPadding: 18),
                  ],
                ),
              ),
            ),

            ..._allRecipesSlivers(catalog),

            // Breathing room above the nav bar below the last row/button.
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
