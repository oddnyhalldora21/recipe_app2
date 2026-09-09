import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipes_search_bar.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Hero shown above the categories/recipe sections: a small kicker pill, a
/// big serif headline, a subtitle and the recipe search bar. Sits directly
/// on the app-wide gradient background rather than painting its own.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key, this.onRecipeSelected});

  final Function(Recipe)? onRecipeSelected;

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser?.email;
    final firstName =
        (email != null && email.contains('@')) ? email.split('@').first : '';
    final greeting = firstName.isEmpty ? 'there' : firstName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 13,
                  color: AppColors.pinkDeep,
                ),
                const SizedBox(width: 6),
                Text(
                  'HI $greeting, WELCOME BACK'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Craving Something\n',
                  style: AppText.serif(fontSize: 28, height: 1.15),
                ),
                TextSpan(
                  text: 'Sweet',
                  style: AppText.serif(
                    fontSize: 28,
                    height: 1.15,
                    color: AppColors.pinkDeep,
                  ),
                ),
                TextSpan(
                  text: ' Today?',
                  style: AppText.serif(fontSize: 28, height: 1.15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Handcrafted desserts and delicate pastries — '
            'discover your next favorite treat.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.brown.withOpacity(0.75),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          RecipesSearchBar(onRecipeSelected: onRecipeSelected),
        ],
      ),
    );
  }
}
