import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({super.key, required this.ingredients});

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.pinkLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: AppColors.pinkDeep,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('Ingredients', style: AppText.serif(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 18),
          ...ingredients.asMap().entries.map((entry) {
            final isLast = entry.key == ingredients.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:
                  isLast
                      ? null
                      : const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.pinkLight,
                            width: 1,
                          ),
                        ),
                      ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.pinkDeep,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.brown,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
