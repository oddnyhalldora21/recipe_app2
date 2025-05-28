import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? customButton;

  const SectionHeader({
    super.key,
    required this.title,
    this.buttonText,
    this.onButtonPressed,
    this.customButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 67, 47, 21),
            ),
          ),
          if (customButton != null)
            customButton!
          else if (buttonText != null && onButtonPressed != null)
            TextButton(
              onPressed: onButtonPressed,
              child: Text(
                buttonText!,
                style: const TextStyle(color: Color.fromARGB(255, 67, 47, 21)),
              ),
            ),
        ],
      ),
    );
  }
}
