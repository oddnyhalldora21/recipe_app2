import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Grouped settings list. Notifications/Collections/Preferences are shown
/// but disabled — there's no feature behind them yet, so they're visibly
/// greyed out with a "Soon" tag rather than silently doing nothing.
class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: const [
            _SettingsRow(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Treats, offers & new recipes',
              enabled: false,
            ),
            Divider(height: 1, color: AppColors.pinkLight),
            _SettingsRow(
              icon: Icons.bookmark_border_rounded,
              title: 'My Collections',
              subtitle: 'Organize your saved desserts',
              enabled: false,
            ),
            Divider(height: 1, color: AppColors.pinkLight),
            _SettingsRow(
              icon: Icons.tune_rounded,
              title: 'Preferences',
              subtitle: 'Diet, flavor & serving sizes',
              enabled: false,
            ),
            Divider(height: 1, color: AppColors.pinkLight),
            _SignOutRow(),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.brown, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.brown,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing:
            enabled
                ? const Icon(Icons.chevron_right, color: AppColors.brownSoft)
                : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pinkLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Soon',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pinkDeep,
                    ),
                  ),
                ),
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  const _SignOutRow();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Supabase.instance.client.auth.signOut(),
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.logout, color: AppColors.brown, size: 20),
      ),
      title: const Text(
        'Sign out',
        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.brown),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.brownSoft),
    );
  }
}
