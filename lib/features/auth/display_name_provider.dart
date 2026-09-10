import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The signed-in user's display name (set at sign-up, editable from
/// Profile), stored in Supabase Auth's user_metadata. Falls back to a
/// capitalized version of the email's local part for older accounts that
/// never set one.
class DisplayNameNotifier extends StateNotifier<String> {
  DisplayNameNotifier() : super(_computeName()) {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      _,
    ) {
      state = _computeName();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  static String _computeName() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 'there';

    final metaName = user.userMetadata?['display_name'] as String?;
    if (metaName != null && metaName.trim().isNotEmpty) {
      return metaName.trim();
    }

    final email = user.email;
    if (email != null && email.contains('@')) {
      final local = email.split('@').first;
      if (local.isEmpty) return 'there';
      return local[0].toUpperCase() + local.substring(1);
    }
    return 'there';
  }

  /// Updates the display name. Returns whether it succeeded.
  Future<bool> updateName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'display_name': trimmed}),
      );
      state = trimmed;
      return true;
    } catch (e) {
      print('Error updating display name: $e');
      return false;
    }
  }
}

final displayNameProvider =
    StateNotifierProvider<DisplayNameNotifier, String>((ref) {
      return DisplayNameNotifier();
    });
