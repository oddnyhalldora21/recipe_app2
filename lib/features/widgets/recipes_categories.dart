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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(category.imageUrl),
                              fit: BoxFit.cover,
                            ),
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
