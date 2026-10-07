import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_header.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_stats.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/add_recipe_button.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/recipe_visibility_tabs.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/user_recipe_grid.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/sign_out_button.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/username_setup_dialog.dart';
import 'package:recipe_app/shared/app_theme.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _promptShown = false;
  RecipeVisibilityFilter _filter = RecipeVisibilityFilter.all;

  void _maybePromptForUsername(ProfileState profileState) {
    if (!kUsernameSetupEnabled) return;
    if (_promptShown || profileState.loading || profileState.hasProfile) {
      return;
    }
    _promptShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const UsernameSetupDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRecipes = ref.watch(userRecipesProvider);
    final shownRecipes = switch (_filter) {
      RecipeVisibilityFilter.public =>
        userRecipes.where((recipe) => recipe.isPublic).toList(),
      RecipeVisibilityFilter.private =>
        userRecipes.where((recipe) => !recipe.isPublic).toList(),
      RecipeVisibilityFilter.all => userRecipes,
    };
    final profileState = ref.watch(profileProvider);
    _maybePromptForUsername(profileState);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          primary: true,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignOutButton(),
              const SizedBox(height: 4),

              const ProfileHeader(),
              const SizedBox(height: 16),

              const ProfileStats(),
              const SizedBox(height: 28),

              // Add New Recipe Button
              const AddRecipeButton(),

              // My Recipes Section Header
              const MyRecipesSection(),
              const SizedBox(height: 12),

              // Public / Private / All filter
              RecipeVisibilityTabs(
                selected: _filter,
                onChanged: (filter) => setState(() => _filter = filter),
              ),
              const SizedBox(height: 20),

              // User Recipes Grid
              UserRecipesGrid(
                userRecipes: shownRecipes,
                emptyTitle: switch (_filter) {
                  RecipeVisibilityFilter.public => 'No public recipes yet',
                  RecipeVisibilityFilter.private => 'No private recipes yet',
                  RecipeVisibilityFilter.all => 'No recipes yet',
                },
                emptyMessage: switch (_filter) {
                  RecipeVisibilityFilter.public =>
                    'Recipes you share with everyone will show up here.',
                  RecipeVisibilityFilter.private =>
                    'Recipes only you can see will show up here.',
                  RecipeVisibilityFilter.all =>
                    'Add your first recipe to see it here.',
                },
              ),
              const SizedBox(height: 28),

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
