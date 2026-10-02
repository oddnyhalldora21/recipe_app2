import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:recipe_app/features/favorites/favorites_page.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/features/saved/saved_page.dart';
import 'package:recipe_app/features/search/search_page.dart';
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
    5,
    (_) => GlobalKey<NavigatorState>(),
  );

  /// One per tab, handed to the tab's root page as its
  /// [PrimaryScrollController] so a re-tap can scroll it back to the top.
  final List<ScrollController> _scrollControllers = List.generate(
    5,
    (_) => ScrollController(),
  );

  static const int _searchTabIndex = 2;

  @override
  void dispose() {
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index == currentIndex) {
      // Tapping the current tab again first pops back to its root, and
      // only once already there scrolls the root back to the top.
      final navigator = _navigatorKeys[index].currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      } else {
        _scrollToTop(index);
      }
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  void _goToProfileTab() => _onDestinationSelected(4);
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

  void _scrollToTop(int index) {
    if (index == _searchTabIndex) return;
    final controller = _scrollControllers[index];
    // No client when the tab's root currently has nothing to scroll (e.g.
    // an empty Favorites or Saved).
    if (!controller.hasClients) return;
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildTab(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      // Only the root page sees this controller — pages pushed on top are
      // their own routes, each with its own PrimaryScrollController.
      onGenerateRoute:
          (settings) => fadeRoute(
            PrimaryScrollController(
              controller: _scrollControllers[index],
              child: child,
            ),
          ),
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
              _buildTab(2, const SearchPage()),
              _buildTab(3, const SavedPage()),
              _buildTab(4, const ProfilePage()),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.brown.withOpacity(0.14)),
              ),
            ),
            child: NavigationBar(
              // Material 3's default 80pt centers ~52pt of icon + label,
              // leaving ~14pt of empty space above and below; 64 trims that.
              height: 64,
              labelPadding: const EdgeInsets.only(top: 2),
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
                    IconsaxPlusLinear.search_normal,
                    color: AppColors.brownSoft,
                  ),
                  selectedIcon: Icon(
                    IconsaxPlusBold.search_normal,
                    color: AppColors.brown,
                  ),
                  label: "Search",
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
