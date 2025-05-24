import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:recipe_app/features/favorites/favorites_page.dart';
import 'package:recipe_app/features/recipes/pages/recipe_page.dart';

class SweetTreat extends StatefulWidget {
  const SweetTreat({super.key});

  @override
  State<SweetTreat> createState() => _SweetTreatState();
}

class _SweetTreatState extends State<SweetTreat> {
  int currentIndex = 0;

  final pages = [RecipePage(), FavoritesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.home),
            selectedIcon: Icon(IconsaxPlusBold.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.heart),
            selectedIcon: Icon(IconsaxPlusBold.heart),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
