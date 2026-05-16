import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/save_repository.dart';
import '../../models/character.dart';
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

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 32),
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
            backgroundColor: enabled
                ? AkyronTheme.violetArcane
                : AkyronTheme.deepNight,
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
