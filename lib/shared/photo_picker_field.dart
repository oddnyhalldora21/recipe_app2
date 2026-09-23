import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/shared/add_photo_placeholder.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Bytes + file extension for a freshly picked photo — everything
/// [RecipeImageUploadService.upload] needs, read once here so callers never
/// have to touch an [XFile] or `dart:io` (keeps this working on web too).
class PickedPhoto {
  const PickedPhoto({required this.bytes, required this.extension});

  final Uint8List bytes;
  final String extension;
}

/// A tappable [AddPhotoPlaceholder] that lets the user take a photo or pick
/// one from their library, previewing it once chosen. It doesn't upload
/// anything itself — [onChanged] just hands the caller the picked bytes,
/// so upload can happen whenever the caller is ready (e.g. on form submit)
/// via [RecipeImageUploadService]. Generic on purpose so both Add Recipe and
/// the upcoming Edit Recipe screen can reuse it as-is.
class PhotoPickerField extends StatefulWidget {
  const PhotoPickerField({super.key, required this.onChanged, this.height = 120});

  final ValueChanged<PickedPhoto?> onChanged;
  final double height;

  @override
  State<PhotoPickerField> createState() => _PhotoPickerFieldState();
}

class _PhotoPickerFieldState extends State<PhotoPickerField> {
  PickedPhoto? _picked;
  bool _busy = false;

  Future<void> _showSourceSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.brown,
                  ),
                  title: const Text('Take Photo'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.brown,
                  ),
                  title: const Text('Choose from Library'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
    );
    if (source == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      final picked = PickedPhoto(
        bytes: bytes,
        extension: _extensionFrom(file.name),
      );
      setState(() => _picked = picked);
      widget.onChanged(picked);
    } catch (e) {
      print('Error picking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access the camera/photos — please try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _extensionFrom(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot == -1 || dot == fileName.length - 1) return 'jpg';
    return fileName.substring(dot + 1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _busy ? null : _showSourceSheet,
      child: Stack(
        children: [
          if (_picked == null)
            AddPhotoPlaceholder(height: widget.height)
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: widget.height,
                child: Image.memory(_picked!.bytes, fit: BoxFit.cover),
              ),
            ),
          if (_picked != null)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          if (_busy)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
