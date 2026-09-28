import 'package:flutter/material.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/features/recipes_pages/all_categories_page.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Categories",
          buttonText: "see all",
          onButtonPressed: () {
            Navigator.push(context, fadeRoute(const AllCategoriesPage()));
          },
        ),
        const SizedBox(height: 12),
        const RecipesCategories(),
      ],
    );
  }
}
