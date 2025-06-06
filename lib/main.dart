import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweet Treats App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 67, 47, 21),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 181, 212),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          titleLarge: GoogleFonts.lato(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 67, 47, 21),
          ),
        ),
        cardTheme: CardTheme(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      home: SweetTreat(),
    );
  }
}
