import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final email =
        Supabase.instance.client.auth.currentUser?.email ?? 'Sweet Treats fan';

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 181, 212),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 67, 47, 21),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 67, 47, 21).withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          email,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        TextButton.icon(
          onPressed: () {
            Supabase.instance.client.auth.signOut();
          },
          icon: const Icon(
            Icons.logout,
            size: 18,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
          label: const Text(
            'Log Out',
            style: TextStyle(
              color: Color.fromARGB(255, 67, 47, 21),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
