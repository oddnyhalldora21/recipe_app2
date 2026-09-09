import 'package:flutter/material.dart';

/// Expanded palette for the app. Keeps the existing pink/brown identity but
/// adds a lighter blush accent and a deeper rose so surfaces don't all read
/// as the same flat pink block.
class AppColors {
  AppColors._();

  static const Color brown = Color(0xFF432F15);
  static const Color brownSoft = Color(0xFF8A6A4E);

  static const Color pink = Color(0xFFF1B5D4);
  static const Color pinkLight = Color(0xFFFCE4EF);
  static const Color pinkDeep = Color(0xFFEC94BF);

  static const Color cream = Color(0xFFFFF8E7);

  /// Soft near-white background used for page canvases, so the saturated
  /// pink can stay reserved for the hero header and accents.
  static const Color background = Color(0xFFFDF4F7);
}

/// Reusable elevation presets so cards/buttons get consistent, warm-toned
/// shadows instead of flat borders or the default grey Material shadow.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.brown.withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.brown.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: AppColors.brown.withOpacity(0.28),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
  ];
}
