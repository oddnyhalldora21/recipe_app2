import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:recipe_app/features/favorites/favorites_page.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/features/saved/saved_page.dart';
import 'package:recipe_app/features/widgets/main_app_bar.dart';
import 'package:recipe_app/home_page.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class SweetTreat extends StatefulWidget {
  const SweetTreat({super.key});

  @override
  State<SweetTreat> createState() => _SweetTreatState();
}

class _SweetTreatState extends State<SweetTreat> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    4,
    (_) => GlobalKey<NavigatorState>(),
  );

  void _onDestinationSelected(int index) {
    if (index == currentIndex) {
      // Tapping the current tab again pops back to its root.
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  void _goToProfileTab() => _onDestinationSelected(3);
  void _goToFavoritesTab() => _onDestinationSelected(1);

  /// The wordmark always lands cleanly on the Home tab's root, even if it
  /// already had a page pushed on top of it.
  void _goHome() {
    _navigatorKeys[0].currentState?.popUntil((route) => route.isFirst);
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });
    }
  }

  Widget _buildTab(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) => fadeRoute(child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Single continuous gradient behind the app bar, tab content and nav
      // bar, so every screen sits on the same surface instead of separate
      // colored blocks.
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final navigator = _navigatorKeys[currentIndex].currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MainAppBar(
            onLogoTap: _goHome,
            onProfileTap: _goToProfileTab,
            onFavoritesTap: _goToFavoritesTab,
          ),
          body: IndexedStack(
            index: currentIndex,
            children: [
              _buildTab(0, RecipePage(onProfileTap: _goToProfileTab)),
              _buildTab(1, const FavoritesPage()),
              _buildTab(2, const SavedPage()),
              _buildTab(3, const ProfilePage()),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.brown.withOpacity(0.14)),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorColor: Colors.white.withOpacity(0.55),
              selectedIndex: currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(
                    IconsaxPlusLinear.home,
                    color: AppColors.brownSoft,
                  ),
                  selectedIcon: Icon(
                    IconsaxPlusBold.home,
                    color: AppColors.brown,
                  ),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(
                    IconsaxPlusLinear.heart,
                    color: AppColors.brownSoft,
                  ),
                  selectedIcon: Icon(
                    IconsaxPlusBold.heart,
                    color: AppColors.brown,
                  ),
                  label: "Favorites",
                ),
                NavigationDestination(
                  icon: Icon(
                    IconsaxPlusLinear.bookmark,
                    color: AppColors.brownSoft,
                  ),
                  selectedIcon: Icon(
                    IconsaxPlusBold.bookmark,
                    color: AppColors.brown,
                  ),
                  label: "Saved",
                ),
                NavigationDestination(
                  icon: Icon(
                    IconsaxPlusLinear.profile,
                    color: AppColors.brownSoft,
                  ),
                  selectedIcon: Icon(
                    IconsaxPlusBold.profile,
                    color: AppColors.brown,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
