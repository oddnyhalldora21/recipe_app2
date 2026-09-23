import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uploads a recipe photo to the `recipe-images` Supabase Storage bucket,
/// under the current user's own folder, and returns its public URL.
///
/// Kept separate from any picker UI so it can be reused as-is by both Add
/// Recipe now and the upcoming Edit Recipe screen — see
/// supabase_setup_recipe_images_storage.sql for the bucket/RLS setup this
/// depends on.
class RecipeImageUploadService {
  RecipeImageUploadService._();

  static const String _bucket = 'recipe-images';

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
      print('Error uploading recipe image: $e');
      return null;
    }
  }
}
