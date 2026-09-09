import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Recipe detail photo: a smaller, fully-rounded card (rather than a
/// full-bleed hero) with the Save and Favorite buttons floating on top.
/// Navigation happens via the persistent top app bar and bottom nav, so
/// there's no back button here.
class ImageFrame extends StatelessWidget {
  const ImageFrame({
    super.key,
    required this.imageUrl,
    required this.favoriteButton,
    required this.saveButton,
  });

  final String imageUrl;
  final Widget favoriteButton;
  final Widget saveButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            SizedBox(
              height: 200,
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
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.28),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  saveButton,
                  const SizedBox(width: 8),
                  favoriteButton,
                ],
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
