import 'package:flutter/material.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Categories"),
        const SizedBox(height: 12),
        const RecipesCategories(),
      ],
    );
  }
}
