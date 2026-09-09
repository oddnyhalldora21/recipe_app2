import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/features/auth/auth_gate.dart';
import 'package:recipe_app/shared/app_theme.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brown),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          titleLarge: GoogleFonts.lato(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: AppColors.brown,
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
