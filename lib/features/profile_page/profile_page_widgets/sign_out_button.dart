import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/confirm_dialog.dart';

/// Small, low-key sign-out control shown at the top of the Profile page —
/// deliberately not a full-width button, since signing out isn't the
/// primary action someone comes to this page for.
class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  /// Signs out only after the user confirms — Cancel or tapping outside the
  /// dialog leaves them signed in.
  Future<void> _confirmAndSignOut(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Sign out?',
      message: 'Are you sure you want to sign out?',
      confirmLabel: 'Yes, sign out',
    );
    if (!confirmed) return;
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => _confirmAndSignOut(context),
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
