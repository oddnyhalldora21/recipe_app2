import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// A themed stand-in for [Switch] — a light-pink track when off, animating
/// to the same darker-pink gradient used for primary buttons when on,
/// instead of Material's default dark/grey thumb-and-track look.
class PinkToggleSwitch extends StatelessWidget {
  const PinkToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: value ? AppGradients.button : AppGradients.background,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
          ),
        ),
      ),
    );
  }
}
