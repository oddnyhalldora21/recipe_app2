import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_header.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/profile_stats.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/my_recipes_section.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/add_recipe_button.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/user_recipe_grid.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/public_profile_section.dart';
import 'package:recipe_app/features/profile_page/profile_page_widgets/recently_added_section.dart'
    as profile_recent;
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

  void _maybePromptForUsername(ProfileState profileState) {
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
    final profileState = ref.watch(profileProvider);
    _maybePromptForUsername(profileState);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignOutButton(),
              const SizedBox(height: 4),

              const ProfileHeader(),
              const SizedBox(height: 16),

              if (profileState.hasProfile) ...[
                PublicProfileSection(profile: profileState.profile!),
                const SizedBox(height: 16),
              ],

              const ProfileStats(),
              const SizedBox(height: 28),

              // Recently Added Section
              const profile_recent.RecentlyAddedSection(),
              const SizedBox(height: 16),

              // My Recipes Section Header
              MyRecipesSection(userRecipes: userRecipes),
              const SizedBox(height: 16),

              // Add New Recipe Button
              const AddRecipeButton(),
              const SizedBox(height: 24),

              // User Recipes Grid
              UserRecipesGrid(userRecipes: userRecipes),
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
