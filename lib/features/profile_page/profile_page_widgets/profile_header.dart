import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/auth/display_name_provider.dart';
import 'package:recipe_app/features/profile_page/profile_data_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/photo_picker_field.dart';
import 'package:recipe_app/shared/primary_button.dart';
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

  void _openEditSheet(BuildContext context, UserProfile? profile) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // Over the whole app rather than inside the tab's own navigator, whose
      // area shrinks once the keyboard is up (same as the recipe sheet).
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _EditProfileSheet(
            initialName: ref.read(displayNameProvider),
            profile: profile,
          ),
    );
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
        gradient: AppGradients.profileCard,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        // Passes the card's full width down, so the centered column below
        // spans the card instead of shrinking to its widest line.
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          Column(
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
                          // Shown at 96pt (288px on a 3x screen) at most, so
                          // 512px leaves headroom while keeping uploads small.
                          maxDimension: 512,
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
              Text(
                displayName,
                textAlign: TextAlign.center,
                style: AppText.serif(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (hasProfile) ...[
                const SizedBox(height: 2),
                Text(
                  // Chosen once at sign-up and permanent for now, so it's shown
                  // here only — the edit sheet covers name and bio.
                  '@${profile!.username}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 4),
              Text(
                email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (hasProfile) ...[
                const SizedBox(height: 14),
                Text(
                  (profile!.bio ?? '').isNotEmpty
                      ? profile.bio!
                      : 'Add a bio to tell others about you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle:
                        (profile.bio ?? '').isNotEmpty
                            ? FontStyle.normal
                            : FontStyle.italic,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            top: -12,
            right: -12,
            child: IconButton(
              onPressed: () => _openEditSheet(context, profile),
              tooltip: 'Edit profile',
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18),
              ),
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Edits the name (Supabase Auth's display_name) and, once a profile row
/// exists, the bio (profiles_sweettreats) together, saving only the fields
/// that changed. Username stays read-only on the card.
///
/// Owns its text controllers so they're disposed exactly when this sheet's
/// element unmounts (after its closing animation finishes) — disposing them
/// right after the sheet's Future returns instead races the still-animating-
/// out TextFields, which threw "A TextEditingController was used after being
/// disposed" in the old name dialog.
class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet({required this.initialName, required this.profile});

  final String initialName;

  /// Null until the user has a profiles_sweettreats row, in which case only
  /// the name can be edited.
  final UserProfile? profile;

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late final _bioController = TextEditingController(
    text: widget.profile?.bio ?? '',
  );
  bool _busy = false;
  String? _nameError;
  String? _bioError;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter your name.');
      return;
    }

    final bio = _bioController.text.trim();
    final nameChanged = name != widget.initialName.trim();
    final bioChanged =
        widget.profile != null && bio != (widget.profile!.bio ?? '').trim();

    setState(() {
      _busy = true;
      _nameError = null;
      _bioError = null;
    });

    final nameSaved =
        !nameChanged ||
        await ref.read(displayNameProvider.notifier).updateName(name);
    final bioSaved =
        !bioChanged ||
        await ref.read(profileProvider.notifier).updateProfile(bio: bio);
    if (!mounted) return;

    if (nameSaved && bioSaved) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _busy = false;
      if (!nameSaved) {
        _nameError = 'Could not save your name — please try again.';
      }
      if (!bioSaved) {
        _bioError = 'Could not save your bio — please try again.';
      }
    });
  }

  InputDecoration _decoration({required String hint, String? error}) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.brown,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Opened over the root navigator, so lift the content above the keyboard
    // (or the home indicator when it's down) ourselves.
    final bottomInset = math.max(
      MediaQuery.viewInsetsOf(context).bottom,
      MediaQuery.paddingOf(context).bottom,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Edit profile', style: AppText.serif(fontSize: 22)),
          const SizedBox(height: 20),
          _label('Name'),
          TextField(
            controller: _nameController,
            enabled: !_busy,
            textCapitalization: TextCapitalization.words,
            decoration: _decoration(hint: 'Your name', error: _nameError),
          ),
          if (widget.profile != null) ...[
            const SizedBox(height: 16),
            _label('Bio'),
            TextField(
              controller: _bioController,
              enabled: !_busy,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoration(
                hint: 'Tell others a little about you (optional)',
                error: _bioError,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _busy ? null : _save,
              child:
                  _busy
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        'Save changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
