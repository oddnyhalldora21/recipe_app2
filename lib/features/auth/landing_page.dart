import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/features/auth/auth_page.dart';
import 'package:recipe_app/shared/fade_page_route.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
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
                      color: const Color.fromARGB(255, 255, 248, 231),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 67, 47, 21),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            67,
                            47,
                            21,
                          ).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cake_rounded,
                      size: 72,
                      color: Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sweet Treats App',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Chocolate, cookies & cozy desserts\nall in one place',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: const Color.fromARGB(
                        255,
                        67,
                        47,
                        21,
                      ).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          fadeRoute(const AuthPage(mode: AuthMode.signUp)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 67, 47, 21),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
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
                        color: const Color.fromARGB(255, 67, 47, 21),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
