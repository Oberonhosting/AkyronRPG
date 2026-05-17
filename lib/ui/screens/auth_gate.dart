import 'package:flutter/material.dart';

import '../../auth/auth_repository.dart';
import '../../auth/session_manager.dart';
import '../../core/theme.dart';
import 'login_screen.dart';
import 'main_menu.dart';

/// Decide, no boot, se vai pro menu (sessão válida) ou pro login.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<Widget>? _next;

  @override
  void initState() {
    super.initState();
    _next = _resolve();
  }

  Future<Widget> _resolve() async {
    final acc = await SessionManager.instance.restore(auth: AuthRepository());
    if (acc != null) {
      return const MainMenu();
    }
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _next,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _LoadingPlaceholder();
        }
        return snap.data ?? const LoginScreen();
      },
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AkyronTheme.obsidian,
      body: Center(
        child: CircularProgressIndicator(color: AkyronTheme.goldEon),
      ),
    );
  }
}
