import 'package:flutter/material.dart';
import 'package:recipe_app/features/all_recipes_page/recently_added_page.dart';
import 'package:recipe_app/features/widgets/recently_added.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Recently Added",
          buttonText: "see all",
          onButtonPressed: () {
            Navigator.push(context, fadeRoute(const RecentlyAddedPage()));
          },
        ),
        const RecentlyAdded(),
      ],
    );
  }
}
