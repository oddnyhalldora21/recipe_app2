import 'package:flutter/material.dart';
import 'package:recipe_app/features/widgets/my_recipes.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class MyRecipesSection extends StatelessWidget {
  const MyRecipesSection({super.key, this.onSeeAllTap});

  final VoidCallback? onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "My Recipes",
          buttonText: "see all",
          onButtonPressed:
              onSeeAllTap ??
              () {
                Navigator.push(context, fadeRoute(const ProfilePage()));
              },
        ),
        const MyRecipesWidget(),
      ],
    );
  }
}
