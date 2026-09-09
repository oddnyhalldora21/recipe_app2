import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Real-data stat cards only (favorites and the user's own recipe count) —
/// no invented metrics like "recipes cooked" since we don't track that.
class ProfileStats extends ConsumerWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesCount = ref.watch(favoritesProvider).length;
    final myRecipesCount = ref.watch(userRecipesProvider).length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.favorite,
            value: favoritesCount,
            label: 'Favorites',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            icon: Icons.menu_book_rounded,
            value: myRecipesCount,
            label: 'My Recipes',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label});

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.pinkLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.pinkDeep, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: AppText.serif(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
