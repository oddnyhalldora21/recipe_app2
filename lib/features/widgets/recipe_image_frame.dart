import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      padding: const EdgeInsets.all(8), // Frame thickness
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 67, 47, 21), // Brown frame color
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 67, 47, 21).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        height: 250,
        width: 300, // Smaller image size
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(
              255,
              241,
              181,
              212,
            ), // Light inner border for extra cuteness
            width: 4,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorState();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildLoadingState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: const Color.fromARGB(255, 255, 248, 231),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cake, size: 40, color: Color.fromARGB(255, 67, 47, 21)),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: const Color.fromARGB(255, 255, 248, 231),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 241, 181, 212),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
