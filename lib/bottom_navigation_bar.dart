import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:recipe_app/features/favorites/favorites_page.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';
import 'package:recipe_app/home_page.dart';
import 'package:recipe_app/shared/app_theme.dart';

class SweetTreat extends StatefulWidget {
  const SweetTreat({super.key});

  @override
  State<SweetTreat> createState() => _SweetTreatState();
}

class _SweetTreatState extends State<SweetTreat> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    3,
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

  void _goToProfileTab() => _onDestinationSelected(2);
  void _goToFavoritesTab() => _onDestinationSelected(1);

  Widget _buildTab(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute:
          (settings) => MaterialPageRoute(builder: (context) => child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final navigator = _navigatorKeys[currentIndex].currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            _buildTab(
              0,
              RecipePage(
                onProfileTap: _goToProfileTab,
                onFavoritesTap: _goToFavoritesTab,
              ),
            ),
            _buildTab(1, const FavoritesPage()),
            _buildTab(2, const ProfilePage()),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            boxShadow: AppShadows.floating,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            child: NavigationBar(
              backgroundColor: AppColors.cream,
              indicatorColor: AppColors.pinkLight,
              selectedIndex: currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(IconsaxPlusLinear.home, color: AppColors.brownSoft),
                  selectedIcon: Icon(IconsaxPlusBold.home, color: AppColors.brown),
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
