import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_header.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_stats.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_settings_list.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/add_recipe_button.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/user_recipe_grid.dart';
import 'package:recipe_app/shared/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRecipes = ref.watch(userRecipesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileHeader(),
              const SizedBox(height: 16),

              const ProfileStats(),
              const SizedBox(height: 28),

              // My Recipes Section Header
              MyRecipesSection(userRecipes: userRecipes),
              const SizedBox(height: 16),

              // Add New Recipe Button
              const AddRecipeButton(),
              const SizedBox(height: 24),

              // User Recipes Grid
              UserRecipesGrid(userRecipes: userRecipes),
              const SizedBox(height: 28),

              const ProfileSettingsList(),
              const SizedBox(height: 20),

              Text(
                'Sweet Treats · Crafted with love & cocoa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
