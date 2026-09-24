import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/auth/display_name_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/app_wordmark.dart';

/// Persistent top bar shown on every screen: the wordmark always jumps back
/// to Home, alongside a favorites shortcut and the profile avatar.
class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.onLogoTap,
    required this.onProfileTap,
    required this.onFavoritesTap,
  });

  final VoidCallback onLogoTap;
  final VoidCallback onProfileTap;
  final VoidCallback onFavoritesTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = ref.watch(displayNameProvider);
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: GestureDetector(
        onTap: onLogoTap,
        behavior: HitTestBehavior.opaque,
        child: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: AppWordmark(fontSize: 22),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onFavoritesTap,
          icon: const Icon(Icons.favorite_border, color: AppColors.brown),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.pinkDeep,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
