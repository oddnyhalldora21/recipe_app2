import 'package:flutter/material.dart';

class AddRecipeBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 300,
            color: Colors.white,
            child: Center(
              child: Text('Test Bottom Sheet!', style: TextStyle(fontSize: 20)),
            ),
          ),
    );
  }
}
