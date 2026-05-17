import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../auth/session_manager.dart';
import '../../core/constants.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import '../../data/save_repository.dart';
import '../../models/character.dart';
import 'auth_gate.dart';
import 'character_creation.dart';
import 'game_screen.dart';
import 'server_browser.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final _repo = SaveRepository();
  List<Character> _saves = [];

  @override
  void initState() {
    super.initState();
    AudioDirector.instance.setMood(MusicMood.mainMenu);
    SessionManager.instance.heartbeat();
    _load();
  }

  Future<void> _load() async {
    try {
      final saves = await _repo.list();
      if (mounted) setState(() => _saves = saves);
    } catch (_) {
      // No primeiro boot, antes do DB existir, ignoramos.
    }
  }

  Future<void> _logout() async {
    AudioDirector.instance.sfx(Sfx.uiBack);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Sua sessão será encerrada. Você precisará logar de novo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await SessionManager.instance.clear();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final acc = SessionManager.instance.currentAccount;
    final totalLE = _saves.fold<int>(0, (s, c) => s + c.coins);

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com gradiente sobre obsidian.
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 1.2,
                colors: [
                  AkyronTheme.violetArcane.withOpacity(0.4),
                  AkyronTheme.obsidian,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Cabeçalho com info da conta.
                if (acc != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle,
                            size: 32, color: AkyronTheme.cyanSpirit),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                acc.username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AkyronTheme.paperBeige,
                                ),
                              ),
                              Text(
                                acc.playerId.formatted,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AkyronTheme.goldEon,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _LEBadge(amount: totalLE),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Sair da conta',
                          icon: const Icon(Icons.logout),
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'AKYRON',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 12,
                    color: AkyronTheme.goldEon,
                  ),
                ),
                const Text(
                  'R     P     G',
                  style: TextStyle(
                    color: AkyronTheme.paperBeige,
                    letterSpacing: 16,
                  ),
                ),
                const Spacer(),
                _MenuButton(
                  label: 'Continuar Jornada',
                  enabled: _saves.isNotEmpty,
                  onTap: () => _enterGame(_saves.first),
                ),
                _MenuButton(
                  label: 'Nova Jornada',
                  onTap: () async {
                    final created = await Navigator.of(context).push<Character>(
                      MaterialPageRoute(
                          builder: (_) => const CharacterCreationScreen()),
                    );
                    if (created != null) {
                      await _repo.save(created);
                      await _load();
                      if (!mounted) return;
                      _enterGame(created);
                    }
                  },
                ),
                _MenuButton(
                  label: 'Servidores Online',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ServerBrowser()),
                  ),
                ),
                _MenuButton(
                  label: 'Códex do Mundo',
                  onTap: () => Navigator.of(context).pushNamed('/lore'),
                ),
                _MenuButton(
                  label: 'Áudio',
                  onTap: () => Navigator.of(context).pushNamed('/audio'),
                ),
                const SizedBox(height: 24),
                Text('v${AkyronK.version}',
                    style: const TextStyle(color: Colors.white38)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _enterGame(Character c) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GameScreen(character: c)),
    );
  }
}

/// Badge com a moeda do jogo (Lascas de Éon).
class _LEBadge extends StatelessWidget {
  const _LEBadge({required this.amount});
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(color: AkyronTheme.goldEon, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.diamond, size: 14, color: AkyronTheme.goldEon),
          const SizedBox(width: 4),
          Text(
            Currency.format(amount),
            style: const TextStyle(
              color: AkyronTheme.goldEon,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: enabled
              ? () {
                  AudioDirector.instance.sfx(Sfx.uiClick);
                  onTap();
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor:
                enabled ? AkyronTheme.violetArcane : AkyronTheme.deepNight,
            foregroundColor: enabled ? Colors.white : Colors.white38,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
