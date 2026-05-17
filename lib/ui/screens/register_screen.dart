import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../auth/auth_repository.dart';
import '../../core/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _auth = AuthRepository();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_passCtrl.text != _pass2Ctrl.text) {
      setState(() => _error = 'As senhas não batem.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    AudioDirector.instance.sfx(Sfx.uiClick);
    final r = await _auth.register(
      username: _userCtrl.text,
      email: _emailCtrl.text,
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
    AudioDirector.instance.sfx(Sfx.unlockSkill);
    // Mostra o ID gerado antes de devolver para o login.
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Conta criada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seu ID público no mundo de Akyron:'),
            const SizedBox(height: 12),
            SelectableText(
              r.account!.playerId.formatted,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AkyronTheme.goldEon,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Compartilhe esse ID para receber convites de party, '
              'guild e servidores privados.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vamos!'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(r.account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _userCtrl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome de usuário',
                      helperText: '3–14 caracteres. Letras, números e _ apenas.',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail (opcional offline)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      helperText: 'Mínimo 4 caracteres.',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pass2Ctrl,
                    obscureText: true,
                    onSubmitted: (_) => _register(),
                    decoration: const InputDecoration(
                      labelText: 'Confirme a senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!,
                        style: const TextStyle(color: AkyronTheme.crimsonAura)),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _register,
                    child: _busy
                        ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('CRIAR CONTA'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sua senha é guardada com SHA-256 + salt aleatório. '
                    'O ID público é único — duas pessoas não podem ter o mesmo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 12),
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
