import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/features/auth/auth_page.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/fade_page_route.dart';
import 'package:recipe_app/shared/primary_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.brown, width: 4),
                        boxShadow: AppShadows.card,
                      ),
                      child: const Icon(
                        Icons.cake_rounded,
                        size: 72,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sweet Treats App',
                      textAlign: TextAlign.center,
                      style: AppText.serif(fontSize: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Chocolate, cookies & cozy desserts\nall in one place',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.brown.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 48),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          fadeRoute(const AuthPage(mode: AuthMode.signUp)),
                        );
                      },
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          fadeRoute(const AuthPage(mode: AuthMode.logIn)),
                        );
                      },
                      child: Text(
                        'Already have an account? Log In',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
