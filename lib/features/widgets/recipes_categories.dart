import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_list_home_page.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_page.dart';

class RecipesCategories extends StatelessWidget {
  const RecipesCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = RecipeCategoryList.getAllCategories();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          RecipeCategoryPage(recipeCategoryList: category),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 80,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Hero(
                        tag: category.id,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.network(
                            category.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              // Show pink background while loading
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
                                      ), // Light pink
                                      const Color.fromARGB(
                                        255,
                                        248,
                                        187,
                                        208,
                                      ), // Slightly lighter pink
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: const Color.fromARGB(
                                      255,
                                      67,
                                      47,
                                      21,
                                    ), // Chocolate brown
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              // Show pink background with icon if image fails to load
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
                                      ), // Light pink
                                      const Color.fromARGB(
                                        255,
                                        248,
                                        187,
                                        208,
                                      ), // Slightly lighter pink
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.cake,
                                    size: 30,
                                    color: const Color.fromARGB(
                                      255,
                                      67,
                                      47,
                                      21,
                                    ), // Chocolate brown
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemCount: categories.length,
      ),
    );
  }
}
