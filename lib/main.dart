import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/auth/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mvlmupvqalbzryjuvdyv.supabase.co',
    anonKey: 'sb_publishable_WVnNKyhi47jWSbWdM4xgSA_iVkN0Svw',
  );

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
        cardTheme: CardThemeData(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
