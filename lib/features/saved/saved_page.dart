import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/saved/collection_recipes_page.dart';
import 'package:recipe_app/features/saved/saved_empty_state.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';
import 'package:recipe_app/shared/responsive.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedRecipesProvider);
    final catalog = ref.watch(recipesCatalogProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: catalog.when(
            data: (recipes) => _SavedBody(saved: saved, catalog: recipes),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: AppColors.pinkDeep),
                ),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    'Could not load your saved recipes.',
                    style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _SavedBody extends StatelessWidget {
  const _SavedBody({required this.saved, required this.catalog});

  final SavedRecipesState saved;
  final List<Recipe> catalog;

  @override
  Widget build(BuildContext context) {
    final allSaved = recipesForLocation(saved, null, catalog);
    final collections = saved.collections;
    final isEmpty = allSaved.isEmpty && collections.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SavedHeader(
          savedCount: allSaved.length,
          collectionCount: collections.length,
        ),
        const SizedBox(height: 20),
        if (isEmpty)
          const Expanded(child: SavedEmptyState())
        else
          Expanded(
            child: ListView(
              children: [
                if (collections.isNotEmpty) ...[
                  Text('Collections', style: AppText.serif(fontSize: 21)),
                  const SizedBox(height: 12),
                  ...collections.map(
                    (collection) => _CollectionTile(
                      collection: collection,
                      recipeCount:
                          recipesForLocation(
                            saved,
                            collection.id,
                            catalog,
                          ).length,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text('All Saved', style: AppText.serif(fontSize: 21)),
                const SizedBox(height: 12),
                if (allSaved.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Recipes you save without picking a collection show up here.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.brown.withOpacity(0.7),
                      ),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: recipeGridColumns(
                                constraints.maxWidth,
                              ),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.68,
                            ),
                        itemCount: allSaved.length,
                        itemBuilder: (context, index) {
                          final recipe = allSaved[index];
                          return RecipeCard(
                            recipe: recipe,
                            heroTag: 'saved_${recipe.id}',
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SavedHeader extends StatelessWidget {
  const _SavedHeader({required this.savedCount, required this.collectionCount});

  final int savedCount;
  final int collectionCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.pink,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bookmark_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saved', style: AppText.serif(fontSize: 26)),
            const SizedBox(height: 2),
            Text(
              '$savedCount saved · $collectionCount collection${collectionCount == 1 ? '' : 's'}',
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({required this.collection, required this.recipeCount});

  final RecipeCollection collection;
  final int recipeCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              fadeRoute(CollectionRecipesPage(collection: collection)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.pinkLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.folder_rounded,
                    color: AppColors.pinkDeep,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    collection.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brown,
                    ),
                  ),
                ),
                Text(
                  '$recipeCount',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.brownSoft,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
