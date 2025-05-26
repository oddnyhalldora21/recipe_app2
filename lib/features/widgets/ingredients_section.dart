// File: lib/features/widgets/ingredients_section.dart
import 'package:flutter/material.dart';

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({super.key, required this.ingredients});

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    // This was your "Cute Ingredients Section"
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 241, 181, 212),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 241, 181, 212).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 181, 212),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_basket_outlined,
                  color: const Color.fromARGB(255, 67, 47, 21),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 67, 47, 21),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...ingredients.asMap().entries.map((entry) {
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 248, 231),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromARGB(
                    255,
                    241,
                    181,
                    212,
                  ).withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 67, 47, 21),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 67, 47, 21),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
