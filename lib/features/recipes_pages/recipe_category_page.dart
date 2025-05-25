import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipes_pages/recipe_category_list_home_page.dart';

class RecipeCategoryPage extends ConsumerWidget {
  const RecipeCategoryPage({super.key, required this.recipeCategoryList});

  final RecipeCategoryList recipeCategoryList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
            crossAxisCount: 2, // 2 cards per row
            crossAxisSpacing: 16, // Space between cards horizontally
            mainAxisSpacing: 20, // Space between cards vertically
            childAspectRatio: 0.75, // Card height ratio
          ),
          itemCount: 10, // 10 cards total (5 rows of 2)
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card
                Expanded(
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
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
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Name and Timer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Recipe name on the left
                    Expanded(
                      child: Text(
                        'Recipe ${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(
                            255,
                            67,
                            47,
                            21,
                          ), // Chocolate brown
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Timer icon on the right
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
                          ), // Chocolate brown
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${15 + (index * 5)} min',
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
            );
          },
        ),
      ),
    );
  }
}
