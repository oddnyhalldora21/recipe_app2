import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The current user's public profile row (profiles_sweettreats) — separate
/// from Supabase Auth's private display_name/user_metadata. Publicly
/// readable by anyone, but only this user can create/edit their own row.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    this.bio,
    this.avatarUrl,
  });

  final String id;
  final String username;
  final String? bio;
  final String? avatarUrl;
}

class ProfileState {
  const ProfileState({this.profile, this.loading = true});

  final UserProfile? profile;
  final bool loading;

  bool get hasProfile => profile != null;

  ProfileState copyWith({UserProfile? profile, bool? loading}) {
    return ProfileState(
      profile: profile ?? this.profile,
      loading: loading ?? this.loading,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState()) {
    _load();
    _authSubscription = _client.auth.onAuthStateChange.listen((_) => _load());
  }

  static const String table = 'profiles_sweettreats';

  SupabaseClient get _client => Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  UserProfile _fromRow(dynamic row) => UserProfile(
    id: row['id'] as String,
    username: row['username'] as String? ?? '',
    bio: row['bio'] as String?,
    avatarUrl: row['avatar_url'] as String?,
  );

  Future<void> _load() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      state = const ProfileState(profile: null, loading: false);
      return;
    }

    state = state.copyWith(loading: true);
    try {
      final row =
          await _client
              .from(table)
              .select('id, username, bio, avatar_url')
              .eq('id', userId)
              .maybeSingle();
      state = ProfileState(
        profile: row == null ? null : _fromRow(row),
        loading: false,
      );
    } catch (e) {
      print('Error loading profile: $e');
      state = state.copyWith(loading: false);
    }
  }

  /// Creates the current user's profile row with a chosen username.
  /// Returns null on failure, otherwise a message describing the failure
  /// is returned via the thrown exception's text so the caller can show
  /// something useful (e.g. a taken username).
  Future<bool> createProfile(String username) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final row =
          await _client
              .from(table)
              .insert({'id': userId, 'username': username.trim()})
              .select()
              .single();
      state = ProfileState(profile: _fromRow(row), loading: false);
      return true;
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  /// Updates username/bio/avatar for the current user's profile.
  /// Returns whether it succeeded.
  Future<bool> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username.trim();
    if (bio != null) updates['bio'] = bio.trim().isEmpty ? null : bio.trim();
    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl.trim().isEmpty ? null : avatarUrl.trim();
    }
    if (updates.isEmpty) return true;

    try {
      await _client.from(table).update(updates).eq('id', userId);
      await _load();
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier();
});
