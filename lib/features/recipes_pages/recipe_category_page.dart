import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_list_home_page.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/recipes_pages/recipe_details.dart';

class RecipeCategoryPage extends ConsumerWidget {
  const RecipeCategoryPage({super.key, required this.recipeCategoryList});

  final RecipeCategoryList recipeCategoryList;

  List<Recipe> getRecipesByCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'chocolate':
        return ChocolateRecipes.getAllChocolateRecipes();
      case 'puff pastry':
        return PuffPastryRecipes.getAllPuffPastryRecipes();
      case 'gluten free':
        return GlutenFreeRecipes.getAllGlutenFreeRecipes();
      case 'frozen':
        return FrozenTreatsRecipes.getAllFrozenTreatsRecipes();
      case 'cookies':
        return CookieRecipes.getAllCookieRecipes();
      case 'vegan':
        return VeganRecipes.getAllVeganRecipes();
      case 'no bake':
        return NoBakeRecipes.getAllNoBakeRecipes();
      case 'no sugar':
        return SugarFreeRecipes.getAllSugarFreeRecipes();
      default:
        return ChocolateRecipes.getAllChocolateRecipes(); // Default fallback
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = getRecipesByCategory(recipeCategoryList.name);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        title: Text(
          recipeCategoryList.name,
          style: TextStyle(
            color: const Color.fromARGB(255, 67, 47, 21),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 67, 47, 21)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Hero(
              tag: recipeCategoryList.id,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(recipeCategoryList.imageUrl),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),

          itemCount: recipes.length > 10 ? 10 : recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(recipe: recipe),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: double.infinity,
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Container(
                              color: const Color.fromARGB(255, 241, 181, 212),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: const Color.fromARGB(255, 67, 47, 21),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromARGB(255, 241, 181, 212),
                                    const Color.fromARGB(255, 248, 187, 208),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.cake,
                                  size: 50,
                                  color: const Color.fromARGB(255, 67, 47, 21),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 67, 47, 21),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: const Color.fromARGB(255, 67, 47, 21),
                          ),
                          SizedBox(width: 4),
                          Text(
                            recipe.cookingTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 67, 47, 21),
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
    );
  }
}
