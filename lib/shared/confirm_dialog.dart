import 'package:flutter/material.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Shared Cancel / confirm dialog, so every "are you sure?" in the app looks
/// the same. Resolves true only when [confirmLabel] is tapped — Cancel and
/// tapping outside both resolve false.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              // pink rather than pinkLight, which nearly vanished on the
              // white dialog surface; still clearly lighter than confirm.
              style: TextButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.brown,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.pinkDark,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        ),
  );
  return confirmed ?? false;
}
