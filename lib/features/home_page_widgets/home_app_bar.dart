import 'package:flutter/material.dart';
import 'package:recipe_app/features/profile_page/my_profile_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(
              Icons.person_outline,
              color: Color.fromARGB(255, 67, 47, 21),
            ),
          ),
        ),
      ],
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi Oddný ",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color.fromARGB(255, 67, 47, 21),
            ),
          ),
          Text(
            "Craving a Sweet Treat?",
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 67, 47, 21),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
