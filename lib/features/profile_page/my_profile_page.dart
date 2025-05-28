import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_header.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/add_recipe_button.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/user_recipe_grid.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRecipes = ref.watch(userRecipesProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 67, 47, 21),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 67, 47, 21)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered Profile Section
            const ProfileHeader(),
            const SizedBox(height: 40),

            // My Recipes Section Header
            MyRecipesSection(userRecipes: userRecipes),
            const SizedBox(height: 20),

            // Add New Recipe Button
            const AddRecipeButton(),
            const SizedBox(height: 30),

            // User Recipes Grid
            UserRecipesGrid(userRecipes: userRecipes),
          ],
        ),
      ),
    );
  }
}
