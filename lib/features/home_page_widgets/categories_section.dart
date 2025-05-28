import 'package:flutter/material.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Categories",
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 67, 47, 21),
          ),
        ),
        const SizedBox(height: 10),
        const RecipesCategories(),
      ],
    );
  }
}
