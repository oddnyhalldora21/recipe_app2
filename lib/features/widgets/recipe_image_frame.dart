import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Full-bleed hero image for the recipe detail page, with a back button and
/// a favorite button floating on top of the image.
class ImageFrame extends StatelessWidget {
  const ImageFrame({
    super.key,
    required this.imageUrl,
    required this.onBack,
    required this.favoriteButton,
  });

  final String imageUrl;
  final VoidCallback onBack;
  final Widget favoriteButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        child: Stack(
          children: [
            SizedBox(
              height: 320,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorState();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingState();
                },
              ),
            ),
            // Scrim so the floating buttons stay legible over any image.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.32),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FloatingCircleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onBack,
                      ),
                      favoriteButton,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: AppColors.cream,
      child: const Center(
        child: Icon(Icons.cake, size: 48, color: AppColors.brown),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppColors.cream,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.pinkDeep,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class _FloatingCircleButton extends StatelessWidget {
  const _FloatingCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.brown),
      ),
    );
  }
}
