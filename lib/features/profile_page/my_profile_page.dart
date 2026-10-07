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

  /// The grid starts with this many recipes and grows by this many each
  /// time the user scrolls near the bottom.
  static const int _pageSize = 30;

  int _visibleCount = _pageSize;

  /// How close to the bottom (in pixels) the next batch is revealed, so it's
  /// already built by the time the user gets there.
  static const double _loadMoreThreshold = 600;

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

    final visibleRecipes =
        shownRecipes.length > _visibleCount
            ? shownRecipes.sublist(0, _visibleCount)
            : shownRecipes;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.depth == 0 &&
                notification.metrics.extentAfter < _loadMoreThreshold &&
                _visibleCount < shownRecipes.length) {
              setState(() => _visibleCount += _pageSize);
            }
            return false;
          },
          child: CustomScrollView(
            primary: true,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
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
                        onChanged:
                            (filter) => setState(() {
                              _filter = filter;
                              _visibleCount = _pageSize;
                            }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // User Recipes Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: UserRecipesGrid(
                  userRecipes: visibleRecipes,
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
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Sweet Treats · Crafted with love & cocoa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
