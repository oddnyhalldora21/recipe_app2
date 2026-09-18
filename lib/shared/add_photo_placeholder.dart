import 'package:flutter/material.dart';

/// Non-functional camera+label placeholder shown wherever the app asks for
/// a photo but doesn't have real upload wired up yet — used instead of a
/// raw image-URL text field, which isn't something a normal user should
/// have to fill in by hand.
class AddPhotoPlaceholder extends StatelessWidget {
  const AddPhotoPlaceholder({super.key, this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.grey[400], size: 28),
          const SizedBox(height: 8),
          Text(
            'Add Photo',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
