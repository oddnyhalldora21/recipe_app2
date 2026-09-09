import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.pinkLight, AppColors.pink],
              ),
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start adding recipes to your favorites\nby tapping the heart icon!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.brown.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
