import 'package:flutter/material.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/features/widgets/all_recipes.dart';
import 'package:recipe_app/features/widgets/recipes_categories.dart';
import 'package:recipe_app/features/widgets/recipes_search_bar.dart';
import 'package:recipe_app/features/widgets/surprise_me.dart';
import 'package:recipe_app/features/recipes_pages/all_recipes_page.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  // Key to force SurpriseMe widget to rebuild with new random recipes
  Key surpriseMeKey = UniqueKey();

  // Function to shuffle the surprise me recipes
  void shuffleSurpriseMe() {
    setState(() {
      surpriseMeKey =
          UniqueKey(); // This forces the widget to rebuild with new random recipes
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        241,
        181,
        212,
      ), // background color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              icon: Icon(
                Icons.person_outline,
                color: const Color.fromARGB(255, 67, 47, 21),
              ),
            ),
          ),
        ],
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi Oddný ",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color.fromARGB(255, 67, 47, 21),
              ),
            ),
            Text(
              "Craving a Sweet Treat?",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 67, 47, 21),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RecipesSearchBar(),
          SizedBox(height: 20),

          Text(
            "Categories",
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 67, 47, 21),
            ),
          ),

          SizedBox(height: 10),

          RecipesCategories(),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Surprise Me!",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
                TextButton.icon(
                  onPressed: shuffleSurpriseMe, // Call the shuffle function
                  icon: Icon(
                    Icons.replay_circle_filled_rounded,
                    size: 18,
                    color: const Color.fromARGB(255, 67, 47, 21),
                  ),
                  label: Text(
                    "shuffle",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SurpriseMe(key: surpriseMeKey),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Recipes",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "see all",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Recipes",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllRecipesPage()),
                    );
                  },
                  child: Text(
                    "see all",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AllRecipes(),
        ],
      ),
    );
  }
}
