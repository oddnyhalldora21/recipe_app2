import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteRecipes = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        248,
        231,
      ), // Cream background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        title: Text(
          "My Favorites",
          style: TextStyle(
            color: const Color.fromARGB(255, 67, 47, 21),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 67, 47, 21)),
      ),
      body:
          favoriteRecipes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          241,
                          181,
                          212,
                        ).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 60,
                        color: const Color.fromARGB(255, 67, 47, 21),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No Favorites Yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 67, 47, 21),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Start adding recipes to your favorites\nby tapping the heart icon!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(
                          255,
                          67,
                          47,
                          21,
                        ).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with count
                    Text(
                      '${favoriteRecipes.length} Favorite${favoriteRecipes.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 67, 47, 21),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Grid of favorite recipes
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: favoriteRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = favoriteRecipes[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          RecipeDetailsPage(recipe: recipe),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recipe Image Card with Heart
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Image.network(
                                            recipe.imageUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                color: const Color.fromARGB(
                                                  255,
                                                  241,
                                                  181,
                                                  212,
                                                ),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              67,
                                                              47,
                                                              21,
                                                            ),
                                                      ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color.fromARGB(
                                                        255,
                                                        241,
                                                        181,
                                                        212,
                                                      ),
                                                      const Color.fromARGB(
                                                        255,
                                                        248,
                                                        187,
                                                        208,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.cake,
                                                    size: 50,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      67,
                                                      47,
                                                      21,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      // Heart icon to remove from favorites
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(
                                                  favoritesProvider.notifier,
                                                )
                                                .removeFromFavorites(recipe.id);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.favorite,
                                              color: const Color.fromARGB(
                                                255,
                                                67,
                                                47,
                                                21,
                                              ),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Category badge
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              67,
                                              47,
                                              21,
                                            ).withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            recipe.category.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 8),

                                // Recipe Name and Cooking Time
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Recipe name
                                    Expanded(
                                      child: Text(
                                        recipe.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            255,
                                            67,
                                            47,
                                            21,
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),

                                    // Cooking time
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 16,
                                          color: const Color.fromARGB(
                                            255,
                                            67,
                                            47,
                                            21,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          recipe.cookingTime,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromARGB(
                                              255,
                                              67,
                                              47,
                                              21,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
