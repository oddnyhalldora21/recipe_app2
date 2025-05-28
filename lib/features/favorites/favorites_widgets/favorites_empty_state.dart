import 'package:flutter/material.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 181, 212).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: Color.fromARGB(255, 67, 47, 21),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 67, 47, 21),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start adding recipes to your favorites\nby tapping the heart icon!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 67, 47, 21).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
