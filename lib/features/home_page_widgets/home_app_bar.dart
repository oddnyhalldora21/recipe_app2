import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/favorites/favorites_saves.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/shared/app_theme.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.onProfileTap, this.onFavoritesTap});

  final VoidCallback? onProfileTap;
  final VoidCallback? onFavoritesTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = Supabase.instance.client.auth.currentUser?.email;
    final initial =
        (email != null && email.isNotEmpty) ? email[0].toUpperCase() : 'S';
    final favoritesCount = ref.watch(favoritesProvider).length;

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Sweet ',
              style: AppText.serif(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: 'Treats.',
              style: AppText.serif(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.pinkDeep,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onFavoritesTap,
              icon: const Icon(
                Icons.favorite_border,
                color: AppColors.brown,
              ),
            ),
            if (favoritesCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.pinkDeep,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$favoritesCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: GestureDetector(
            onTap:
                onProfileTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
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
