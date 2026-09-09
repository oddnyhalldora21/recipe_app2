import 'package:flutter/material.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';
import 'package:recipe_app/shared/app_theme.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Categories",
          customButton: Text(
            'Swipe to explore',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const RecipesCategories(),
      ],
    );
  }
}
