import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/bottom_navigation_bar.dart';
import 'package:recipe_app/features/auth/landing_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final StreamSubscription<AuthState> _authSubscription;
  Session? _session;

  @override
  void initState() {
    super.initState();
    _session = Supabase.instance.client.auth.currentSession;
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      setState(() {
        _session = data.session;
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _session == null ? const LandingPage() : const SweetTreat();
  }
}
