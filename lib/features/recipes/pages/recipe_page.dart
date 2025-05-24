import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi Oddný", style: TextStyle(fontSize: 15)),
            Text("Craving a Sweet Treat?"),
          ],
        ),
      ),
    );
  }
}
