import 'package:flutter/material.dart';

class RecipesSearchBar extends StatelessWidget {
  const RecipesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SearchAnchor.bar(
      barHintText: "what are we craving?",
      barElevation: WidgetStatePropertyAll(0.2),
      barSide: WidgetStatePropertyAll(
        BorderSide(color: Color.fromARGB(255, 67, 47, 21)),
      ),
      viewBackgroundColor: theme.colorScheme.surfaceContainerLowest,
      barBackgroundColor: WidgetStateProperty.all(
        const Color.fromARGB(255, 255, 237, 207),
      ),
      suggestionsBuilder: (context, controller) {
        return [];
      },
    );
  }
}
