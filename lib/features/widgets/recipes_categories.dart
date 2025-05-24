import 'package:flutter/material.dart';

class RecipesCategories extends StatelessWidget {
  const RecipesCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(child: SizedBox(width: 80, child: Card())),

              Text("${index + 1}"),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemCount: 8,
      ),
    );
  }
}
