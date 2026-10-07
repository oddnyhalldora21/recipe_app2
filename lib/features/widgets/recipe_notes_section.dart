import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// "Recipe notes" card under the instructions, in the same card style as
/// [InstructionsSection]. The text keeps the line breaks it was typed with.
class RecipeNotesSection extends StatelessWidget {
  const RecipeNotesSection({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                  Icons.sticky_note_2_outlined,
                  color: AppColors.pinkDeep,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('Recipe notes', style: AppText.serif(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            notes,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.brown,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
