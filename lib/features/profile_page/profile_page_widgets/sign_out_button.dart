import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Small, low-key sign-out control shown at the top of the Profile page —
/// deliberately not a full-width button, since signing out isn't the
/// primary action someone comes to this page for.
class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => Supabase.instance.client.auth.signOut(),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textMuted,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        icon: const Icon(Icons.logout, size: 15),
        label: const Text(
          'Sign out',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
