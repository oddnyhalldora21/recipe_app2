import 'package:flutter/material.dart';
import 'package:recipe_app/features/widgets/surprise_me.dart';
import 'package:recipe_app/features/home_page_widgets/section_header.dart';

class SurpriseMeSection extends StatefulWidget {
  const SurpriseMeSection({super.key});

  @override
  State<SurpriseMeSection> createState() => _SurpriseMeSectionState();
}

class _SurpriseMeSectionState extends State<SurpriseMeSection> {
  Key surpriseMeKey = UniqueKey();

  void shuffleSurpriseMe() {
    setState(() {
      surpriseMeKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Surprise Me!",
          customButton: TextButton.icon(
            onPressed: shuffleSurpriseMe,
            icon: const Icon(
              Icons.replay_circle_filled_rounded,
              size: 18,
              color: Color.fromARGB(255, 67, 47, 21),
            ),
            label: const Text(
              "shuffle",
              style: TextStyle(color: Color.fromARGB(255, 67, 47, 21)),
            ),
          ),
        ),
        SurpriseMe(key: surpriseMeKey),
      ],
    );
  }
}
