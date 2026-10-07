import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Which of the user's own recipes the Profile grid shows.
enum RecipeVisibilityFilter {
  public('Public'),
  private('Private'),
  all('All');

  const RecipeVisibilityFilter(this.label);

  final String label;
}

/// Public / Private / All pill tabs above the Profile recipe grid. The
/// selected pill is filled pink like the primary buttons; the others are
/// outlined in the same pink.
class RecipeVisibilityTabs extends StatelessWidget {
  const RecipeVisibilityTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RecipeVisibilityFilter selected;
  final ValueChanged<RecipeVisibilityFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    // Equal thirds of the row, with 8px gaps between (not after) the pills.
    return Row(
      children: [
        for (final filter in RecipeVisibilityFilter.values) ...[
          if (filter != RecipeVisibilityFilter.values.first)
            const SizedBox(width: 8),
          Expanded(
            child: _TabPill(
              label: filter.label,
              selected: filter == selected,
              onTap: () => onChanged(filter),
            ),
          ),
        ],
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            gradient: selected ? AppGradients.button : null,
            color: selected ? null : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              // Same width either way, so the pill doesn't change size.
              color: selected ? Colors.transparent : AppColors.pinkDark,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.pinkDark,
            ),
          ),
        ),
      ),
    );
  }
}
