import 'package:flutter/material.dart';
import 'package:recipe_app/features/widgets/my_recipes.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';

class MyRecipesSection extends StatelessWidget {
  const MyRecipesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "My Recipes",
          buttonText: "see all",
          onButtonPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        const MyRecipesWidget(),
      ],
    );
  }
}
