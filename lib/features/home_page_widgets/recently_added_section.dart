import 'package:flutter/material.dart';
import 'package:recipe_app/features/widgets/recently_added.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionHeader(title: "Recently Added"),
        RecentlyAdded(),
      ],
    );
  }
}
