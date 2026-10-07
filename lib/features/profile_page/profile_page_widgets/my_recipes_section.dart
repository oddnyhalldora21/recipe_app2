import 'package:flutter/material.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';

class MyRecipesSection extends StatelessWidget {
  const MyRecipesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionHeader(title: 'My Recipes', topPadding: 20);
  }
}
