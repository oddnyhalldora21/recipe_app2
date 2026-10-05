import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? customButton;

  /// Space above the title. Home keeps its sections tight; Profile passes
  /// a roomier value.
  final double topPadding;

  const SectionHeader({
    super.key,
    required this.title,
    this.buttonText,
    this.onButtonPressed,
    this.customButton,
    this.topPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppText.serif(fontSize: 21)),
          if (customButton != null)
            customButton!
          else if (buttonText != null && onButtonPressed != null)
            TextButton(
              onPressed: onButtonPressed,
              child: Text(
                buttonText!,
                style: const TextStyle(color: AppColors.brown),
              ),
            ),
        ],
      ),
    );
  }
}
