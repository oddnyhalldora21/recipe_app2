import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/app_wordmark.dart';

/// Shows the login page's wordmark and tagline (without its buttons) over
/// [child] when the app opens, then fades away. [child] is built underneath
/// from the start, so the first page is already loading during the splash.
class SplashOverlay extends StatefulWidget {
  const SplashOverlay({super.key, required this.child});

  final Widget child;

  /// How long the wordmark stays fully visible before the splash fades out.
  static const Duration hold = Duration(milliseconds: 1500);

  @override
  State<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<SplashOverlay> {
  static const _fade = Duration(milliseconds: 400);

  bool _textVisible = false;
  bool _splashVisible = true;
  bool _splashRemoved = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    // Wait for the fonts so the text doesn't appear in a fallback font and
    // then jump. If they can't load (e.g. offline on first launch), carry
    // on with the fallback rather than hang on the splash.
    try {
      await GoogleFonts.pendingFonts([
        AppText.serif(),
        GoogleFonts.lato(),
      ]).timeout(const Duration(seconds: 2));
    } catch (_) {}
    if (!mounted) return;
    setState(() => _textVisible = true);

    await Future<void>.delayed(SplashOverlay.hold);
    if (!mounted) return;
    setState(() => _splashVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_splashRemoved)
          // Blocks taps on the page underneath until the splash is gone.
          AbsorbPointer(
            child: AnimatedOpacity(
              opacity: _splashVisible ? 1 : 0,
              duration: _fade,
              curve: Curves.easeOut,
              onEnd: () {
                if (!_splashVisible) setState(() => _splashRemoved = true);
              },
              child: _buildSplash(),
            ),
          ),
      ],
    );
  }

  /// Same gradient, wordmark, tagline and layout as LandingPage.
  Widget _buildSplash() {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      // Material so the text gets normal styling instead of Flutter's
      // debug underline.
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AnimatedOpacity(
                  opacity: _textVisible ? 1 : 0,
                  duration: _fade,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppWordmark(
                        fontSize: 36,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Chocolate, cookies & cozy desserts\nall in one place',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.brown.withOpacity(0.8),
                        ),
                      ),
                      // Empty space where LandingPage has its buttons (48 gap
                      // + 56 button + 16 gap + 48 text button), so the
                      // wordmark sits at the same height as on that page.
                      const SizedBox(height: 168),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
