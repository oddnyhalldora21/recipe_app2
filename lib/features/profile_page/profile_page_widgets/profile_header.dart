import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
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

        const Text(
          'Oddný Halldóra',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
