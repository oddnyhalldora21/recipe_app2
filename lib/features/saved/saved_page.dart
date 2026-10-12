import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/saved/all_saved_page.dart';
import 'package:recipe_app/features/saved/collection_recipes_page.dart';
import 'package:recipe_app/features/saved/favorites_recipes_page.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

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

class _SavedBody extends ConsumerWidget {
  const _SavedBody({required this.saved, required this.catalog});

  final SavedRecipesState saved;
  final List<Recipe> catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesCount = ref.watch(favoritesProvider).length;
    final allSaved = recipesForLocation(saved, null, catalog);
    final collections = saved.collections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SavedHeader(
          savedCount: allSaved.length,
          collectionCount: collections.length,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            primary: true,
            children: [
              // Favorites is pinned first and can't be renamed, moved or
              // deleted, so it never gets a ⋮ menu.
              _FolderTile(
                icon: Icons.favorite_rounded,
                name: 'Favorites',
                recipeCount: favoritesCount,
                onTap:
                    () => Navigator.push(
                      context,
                      fadeRoute(
                        const FavoritesRecipesPage(),
                        settings: const RouteSettings(
                          name: FavoritesRecipesPage.routeName,
                        ),
                      ),
                    ),
              ),
              _FolderTile(
                icon: Icons.bookmark_rounded,
                name: 'All Saved',
                recipeCount: allSaved.length,
                onTap:
                    () => Navigator.push(
                      context,
                      fadeRoute(const AllSavedPage()),
                    ),
              ),
              const SizedBox(height: 14),
              Text('Collections', style: AppText.serif(fontSize: 21)),
              const SizedBox(height: 12),
              if (collections.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Create a collection from the save button on any recipe.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.brown.withValues(alpha: 0.7),
                    ),
                  ),
                )
              else
                for (final collection in collections)
                  _FolderTile(
                    icon: Icons.folder_rounded,
                    name: collection.name,
                    recipeCount:
                        recipesForLocation(
                          saved,
                          collection.id,
                          catalog,
                        ).length,
                    onTap:
                        () => Navigator.push(
                          context,
                          fadeRoute(
                            CollectionRecipesPage(collection: collection),
                          ),
                        ),
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

class _FolderTile extends StatelessWidget {
  const _FolderTile({
    required this.icon,
    required this.name,
    required this.recipeCount,
    required this.onTap,
  });

  final IconData icon;
  final String name;
  final int recipeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
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
                  child: Icon(icon, color: AppColors.pinkDeep, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
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
