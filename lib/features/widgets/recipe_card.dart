import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

/// Shared recipe card used across the home carousels, the favorites/profile/
/// all-recipes grids: image with a time pill and favorite heart floating on
/// top, then category, name and an ingredient-count pill below on the page
/// background (matches the editorial card style used throughout the app).
class RecipeCard extends ConsumerWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.heroTag,
    this.showMineBadge = false,
    this.showVisibilityBadge = false,
  });

  final Recipe recipe;
  final String heroTag;
  final bool showMineBadge;

  /// Shows a "Public"/"Private" pill instead of the plain "MINE" badge —
  /// used on Profile's Recently Added, where every card is already the
  /// user's own, so what matters is whether others can see it.
  final bool showVisibilityBadge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited = ref.watch(
      favoritesProvider.select((f) => f.any((r) => r.id == recipe.id)),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          fadeRoute(RecipeDetailsPage(recipe: recipe)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: heroTag,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppShadows.card,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.pinkLight,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.brown,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.pink, AppColors.pinkDeep],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.cake,
                                size: 40,
                                color: AppColors.brown,
                              ),
                            ),
                          );
                        },
                      ),
                      if (showVisibilityBadge)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _VisibilityBadge(isPublic: recipe.isPublic),
                        )
                      else if (showMineBadge)
                        Positioned(top: 8, left: 8, child: _MineBadge()),
                      if (recipe.cookingTime.isNotEmpty)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: _Pill(
                            icon: Icons.access_time_rounded,
                            label: recipe.cookingTime,
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _FavoriteButton(
                          recipe: recipe,
                          isFavorited: isFavorited,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(recipe.category.toUpperCase(), style: AppText.label),
          const SizedBox(height: 2),
          Text(
            recipe.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.serif(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.pinkLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${recipe.ingredients.length} ingredients',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.brown),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class _MineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.brown.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'MINE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _VisibilityBadge extends StatelessWidget {
  const _VisibilityBadge({required this.isPublic});

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:
            (isPublic ? Colors.green[700]! : AppColors.brown).withOpacity(
              0.9,
            ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPublic ? Icons.public : Icons.lock_outline,
            size: 9,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            isPublic ? 'PUBLIC' : 'PRIVATE',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.recipe, required this.isFavorited});

  final Recipe recipe;
  final bool isFavorited;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(recipe),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: AppShadows.soft,
        ),
        child: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          size: 16,
          color: isFavorited ? AppColors.pinkDeep : AppColors.brown,
        ),
      ),
    );
  }
}
