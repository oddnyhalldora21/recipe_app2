import 'package:flutter/material.dart';

class CookingTimeCard extends StatelessWidget {
  const CookingTimeCard({super.key, required this.cookingTime});

  final String cookingTime;

  @override
  Widget build(BuildContext context) {
    // This was your "Recipe Title with cute styling" section
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 241, 181, 212),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: const Color.fromARGB(255, 67, 47, 21),
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            'Cooking Time: $cookingTime',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 67, 47, 21),
            ),
          ),
        ],
      ),
    );
  }
}
