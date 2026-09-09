import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

class SavedEmptyState extends StatelessWidget {
  const SavedEmptyState({super.key});

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
              Icons.bookmark_border_rounded,
              size: 60,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nothing Saved Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the bookmark icon on a recipe\nto save it here or start a collection.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.brown.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
