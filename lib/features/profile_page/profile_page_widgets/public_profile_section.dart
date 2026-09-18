import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Shows the current user's public profile (username/bio/avatar) with an
/// edit affordance. This is what other users see on the creator profile
/// page — separate from the private Supabase-Auth display name above it.
class PublicProfileSection extends StatelessWidget {
  const PublicProfileSection({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
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
                      onTap:
                          () => showDialog<void>(
                            context: context,
                            builder:
                                (context) =>
                                    _EditProfileDialog(profile: profile),
                          ),
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

/// Owns its own text controllers so they're disposed exactly when this
/// dialog's element unmounts (after its closing animation finishes) —
/// disposing them right after `showDialog` returns instead races the
/// dialog's still-rebuilding, still-animating-out TextFields.
class _EditProfileDialog extends ConsumerStatefulWidget {
  const _EditProfileDialog({required this.profile});

  final UserProfile profile;

  @override
  ConsumerState<_EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<_EditProfileDialog> {
  late final _usernameController = TextEditingController(
    text: widget.profile.username,
  );
  late final _bioController = TextEditingController(
    text: widget.profile.bio ?? '',
  );
  late final _avatarController = TextEditingController(
    text: widget.profile.avatarUrl ?? '',
  );
  bool _busy = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final username = _usernameController.text.trim();
    if (username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username must be at least 3 characters.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _busy = true);
    final success = await ref
        .read(profileProvider.notifier)
        .updateProfile(
          username: username,
          bio: _bioController.text,
          avatarUrl: _avatarController.text,
        );
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not update your profile — please try again.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit public profile', style: AppText.serif(fontSize: 20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              enabled: !_busy,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              enabled: !_busy,
              decoration: const InputDecoration(labelText: 'Bio (optional)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _avatarController,
              enabled: !_busy,
              decoration: const InputDecoration(
                labelText: 'Avatar image URL (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _busy ? null : _save,
          child:
              _busy
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Save'),
        ),
      ],
    );
  }
}
