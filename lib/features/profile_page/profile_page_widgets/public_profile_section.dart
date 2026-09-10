import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Shows the current user's public profile (username/bio/avatar) with an
/// edit affordance. This is what other users see on the creator profile
/// page — separate from the private Supabase-Auth display name above it.
class PublicProfileSection extends ConsumerWidget {
  const PublicProfileSection({super.key, required this.profile});

  final UserProfile profile;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final usernameController = TextEditingController(text: profile.username);
    final bioController = TextEditingController(text: profile.bio ?? '');
    final avatarController = TextEditingController(
      text: profile.avatarUrl ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit public profile', style: AppText.serif(fontSize: 20)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Bio (optional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: avatarController,
                    decoration: const InputDecoration(
                      labelText: 'Avatar image URL (optional)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != true) {
      usernameController.dispose();
      bioController.dispose();
      avatarController.dispose();
      return;
    }

    final username = usernameController.text.trim();
    final bio = bioController.text;
    final avatarUrl = avatarController.text;
    usernameController.dispose();
    bioController.dispose();
    avatarController.dispose();

    if (username.length < 3) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username must be at least 3 characters.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final success = await ref
        .read(profileProvider.notifier)
        .updateProfile(username: username, bio: bio, avatarUrl: avatarUrl);

    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update your profile — please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBio = (profile.bio ?? '').isNotEmpty;
    final hasAvatar = (profile.avatarUrl ?? '').isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.pinkLight,
            backgroundImage: hasAvatar ? NetworkImage(profile.avatarUrl!) : null,
            child:
                hasAvatar
                    ? null
                    : Text(
                      profile.username.isNotEmpty
                          ? profile.username[0].toUpperCase()
                          : '?',
                      style: AppText.serif(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                      ),
                    ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '@${profile.username}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brown,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _edit(context, ref),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  hasBio ? profile.bio! : 'Add a bio to tell others about you.',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: hasBio ? FontStyle.normal : FontStyle.italic,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
