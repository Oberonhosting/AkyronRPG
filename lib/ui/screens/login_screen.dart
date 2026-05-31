import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../auth/auth_models.dart';
import '../../auth/auth_repository.dart';
import '../../auth/session_manager.dart';
import '../../core/theme.dart';
import 'main_menu.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthRepository();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    AudioDirector.instance.sfx(Sfx.uiClick);
    final r = await _auth.login(
      usernameOrEmail: _userCtrl.text,
      password: _passCtrl.text,
    );
    if (!mounted) return;
    if (!r.success) {
      setState(() {
        _busy = false;
        _error = r.error;
      });
      return;
    }
    await SessionManager.instance.persist(r.account!);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainMenu()),
    );
  }

  Future<void> _goRegister() async {
    AudioDirector.instance.sfx(Sfx.uiClick);
    final created = await Navigator.of(context).push<Account>(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
    if (created != null && mounted) {
      await SessionManager.instance.persist(created);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 1.2,
                colors: [
                  AkyronTheme.violetArcane.withOpacity(0.35),
                  AkyronTheme.obsidian,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'AKYRON',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10,
                          color: AkyronTheme.goldEon,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'entre na sua jornada',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AkyronTheme.paperBeige,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 36),
                      TextField(
                        controller: _userCtrl,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Usuário ou e-mail',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        onSubmitted: (_) => _login(),
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(color: AkyronTheme.crimsonAura),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _login,
                        child: _busy
                            ? const SizedBox(
                                height: 18, width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('ENTRAR'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _busy ? null : _goRegister,
                        child: const Text('Criar conta nova'),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'sua sessão fica salva 30 dias',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
