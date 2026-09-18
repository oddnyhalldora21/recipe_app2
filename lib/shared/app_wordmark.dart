import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// The app's text wordmark — "Sweet" in the default heading color,
/// "Treats." in the accent pink — used wherever the logo appears (app bar,
/// landing screen), so every screen shows the exact same mark instead of
/// each one styling its own copy.
class AppWordmark extends StatelessWidget {
  const AppWordmark({super.key, this.fontSize = 22, this.textAlign});

  final double fontSize;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Sweet ',
            style: AppText.serif(fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: 'Treats.',
            style: AppText.serif(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.pinkDeep,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
