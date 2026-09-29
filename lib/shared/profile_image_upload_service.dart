import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uploads a profile avatar to the `avatars` Supabase Storage bucket, under
/// the current user's own folder, and returns its public URL.
///
/// Mirrors [RecipeImageUploadService] exactly, just pointed at a separate
/// bucket so avatars and recipe photos don't mix — see
/// supabase_setup_avatars_storage.sql for the bucket/RLS setup this depends
/// on.
class ProfileImageUploadService {
  ProfileImageUploadService._();

  static const String _bucket = 'avatars';

  /// Returns the public URL on success, or null if the upload failed (no
  /// signed-in user, or a network/storage error) — callers decide what to
  /// fall back to.
  static Future<String?> upload({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final path =
        '$userId/${DateTime.now().microsecondsSinceEpoch}.$fileExtension';

    try {
      await Supabase.instance.client.storage
          .from(_bucket)
          .uploadBinary(path, bytes);
      return Supabase.instance.client.storage.from(_bucket).getPublicUrl(path);
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }
}
