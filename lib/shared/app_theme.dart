import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  /// A deeper, more saturated pink — same family as [pinkDeep], just dark
  /// enough to carry white button text. Used for primary buttons instead
  /// of the old brown fill.
  static const Color pinkDark = Color(0xFFC2477F);

  static const Color cream = Color(0xFFFFF8E7);

  /// Soft near-white background used for page canvases, so the saturated
  /// pink can stay reserved for the hero header and accents.
  static const Color background = Color(0xFFFDF4F7);

  /// Warm grey for secondary/caption text on white or blush surfaces.
  static const Color textMuted = Color(0xFF9C8778);
}

/// Editorial serif for display copy (titles, recipe names) paired with the
/// existing sans body font, so headings read a step more boutique/bakery.
class AppText {
  AppText._();

  static TextStyle serif({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.brown,
    double? height,
  }) => GoogleFonts.playfairDisplay(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );

  /// Small uppercase kicker used for recipe category tags.
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.pinkDeep,
  );
}

/// Shared gradients painted behind whole screens/bars, so the pink wash reads
/// as one continuous surface rather than separate colored blocks.
class AppGradients {
  AppGradients._();

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.pinkLight, AppColors.pink],
  );

  /// Softer alternative to a flat AppColors.brown fill, used on Profile
  /// banners so they read as warm rather than heavy.
  static const LinearGradient brownSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brownSoft, AppColors.brown],
  );

  /// The app's primary-button fill — a darker pink gradient, used instead
  /// of a flat brown fill so buttons read as an extension of the existing
  /// pink palette rather than a separate color scheme.
  static const LinearGradient button = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.pinkDeep, AppColors.pinkDark],
  );
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
