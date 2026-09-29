import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/auth/display_name_provider.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/shared/add_photo_placeholder.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/photo_picker_field.dart';
import 'package:recipe_app/shared/profile_image_upload_service.dart';

/// One card covering both the private (name/email, always shown) and public
/// (username/bio, only once a profiles_sweettreats row exists) identity —
/// previously two separate cards (ProfileHeader + PublicProfileSection),
/// merged so the avatar/name/username/bio all read as one profile block.
class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  bool _uploadingAvatar = false;

  Future<void> _editName(BuildContext context) async {
    final controller = TextEditingController(
      text: ref.read(displayNameProvider),
    );
    final newName = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit name', style: AppText.serif(fontSize: 20)),
            content: TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Your name'),
              onSubmitted: (value) => Navigator.of(context).pop(value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(controller.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    controller.dispose();
    if (newName == null || newName.trim().isEmpty) return;

    final success = await ref
        .read(displayNameProvider.notifier)
        .updateName(newName);

    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update your name — please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _onAvatarPicked(PickedPhoto? photo) async {
    if (photo == null) return;

    setState(() => _uploadingAvatar = true);
    final uploadedUrl = await ProfileImageUploadService.upload(
      bytes: photo.bytes,
      fileExtension: photo.extension,
    );
    if (!mounted) return;

    if (uploadedUrl == null) {
      setState(() => _uploadingAvatar = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not upload your photo — please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final success = await ref
        .read(profileProvider.notifier)
        .updateProfile(avatarUrl: uploadedUrl);
    if (!mounted) return;

    setState(() => _uploadingAvatar = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your photo — please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = ref.watch(displayNameProvider);
    final email =
        Supabase.instance.client.auth.currentUser?.email ?? 'Sweet Treats fan';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S';
    final profileState = ref.watch(profileProvider);
    final hasProfile = profileState.hasProfile;
    final profile = profileState.profile;

    final avatarPlaceholder = Container(
      decoration: const BoxDecoration(
        color: AppColors.pinkDeep,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: AppText.serif(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.brownSoft,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (hasProfile)
                  IgnorePointer(
                    ignoring: _uploadingAvatar,
                    child: PhotoPickerField(
                      height: 96,
                      shape: BoxShape.circle,
                      initialImageUrl: profile!.avatarUrl,
                      placeholder: avatarPlaceholder,
                      onChanged: _onAvatarPicked,
                    ),
                  )
                else
                  avatarPlaceholder,
                if (_uploadingAvatar)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  style: AppText.serif(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _editName(context),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            email,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
          if (hasProfile) ...[
            const SizedBox(height: 20),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white.withOpacity(0.14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    '@${profile!.username}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
                            (context) => _EditProfileDialog(profile: profile),
                      ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              (profile.bio ?? '').isNotEmpty
                  ? profile.bio!
                  : 'Add a bio to tell others about you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontStyle:
                    (profile.bio ?? '').isNotEmpty
                        ? FontStyle.normal
                        : FontStyle.italic,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Owns its own text controllers so they're disposed exactly when this
/// dialog's element unmounts (after its closing animation finishes) —
/// disposing them right after `showDialog` returns instead races the
/// dialog's still-rebuilding, still-animating-out TextFields.
///
/// Moved here unchanged from the now-deleted public_profile_section.dart —
/// only its file location changed, not its logic, since there's a separate
/// open investigation into a crash in this exact dialog.
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
  bool _busy = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
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
        .updateProfile(username: username, bio: _bioController.text);
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
            const AddPhotoPlaceholder(height: 100),
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
