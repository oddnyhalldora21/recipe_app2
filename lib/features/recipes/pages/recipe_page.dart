import 'package:flutter/material.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';
import 'package:recipe_app/features/widgets/recipes_search_bar.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi Oddný ", style: theme.textTheme.bodyLarge),
            Text(
              "Craving a Sweet Treat?",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 67, 47, 21),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RecipesSearchBar(),
          SizedBox(height: 20),

          Text(
            "Categories",
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 67, 47, 21),
            ),
          ),

          SizedBox(height: 10),

          RecipesCategories(),
        ],
      ),
    );
  }
}
