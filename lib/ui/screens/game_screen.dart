import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/theme.dart';
import '../../game/akyron_game.dart';
import '../../game/world/region.dart';
import '../../models/character.dart';
import '../../models/enums.dart';
import '../../systems/progression/leveling.dart';
import '../widgets/chapter_intro.dart';
import '../widgets/level_up_overlay.dart';
import '../widgets/stat_bar.dart';
import 'combat_screen.dart';
import 'equipment_screen.dart';

/// Tela principal de exploração. Hospeda o GameWidget do Flame + HUD
/// Material por cima (stats, botão de batalha de teste, botão de inventário,
/// etc.).
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.character});

  final Character character;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final AkyronGame _game = AkyronGame(character: widget.character);
  bool _showChapter = true;
  LevelUpResult? _pendingLevelUp;
  Timer? _moodTicker;

  bool get _isMobile {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Stinger de capítulo, depois a trilha da região (após o stinger sair).
    AudioDirector.instance.playStinger(MusicMood.chapterIntro);
    Future.delayed(const Duration(milliseconds: 2900), _applyExploreMood);
    // Reavalia mood (HP, clima) a cada 4 s.
    _moodTicker = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _applyExploreMood(),
    );
  }

  void _applyExploreMood() {
    if (!mounted) return;
    final region = WorldRegions.byId(widget.character.region);
    final base = AudioDirector.instance.pickExploreMood(widget.character);
    final mood =
        AudioDirector.instance.applyWeatherOverride(base, _game.weather, region);
    AudioDirector.instance.setMood(mood);
  }

  @override
  void dispose() {
    _moodTicker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final region = WorldRegions.byId(widget.character.region);
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'hud': (ctx, _) => _buildHud(),
              'mobileJoystick': (ctx, _) => _MobileJoystickPad(game: _game),
            },
            initialActiveOverlays: ['hud', if (_isMobile) 'mobileJoystick'],
          ),
          if (_showChapter)
            ChapterIntro(
              chapter: 'CAPÍTULO I',
              title: region.title,
              subtitle: 'Sua aura começa a vazar.',
              onDone: () => setState(() => _showChapter = false),
            ),
          if (_pendingLevelUp != null)
            LevelUpOverlay(
              result: _pendingLevelUp!,
              onDismiss: () => setState(() => _pendingLevelUp = null),
            ),
        ],
      ),
    );
  }

  Widget _buildHud() {
    final s = widget.character.baseStats;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(text: widget.character.playerId.formatted, color: AkyronTheme.violetArcane),
              const SizedBox(width: 8),
              _Pill(text: 'Lv ${widget.character.level}', color: AkyronTheme.goldEon),
              const SizedBox(width: 8),
              _Pill(text: widget.character.power.formName, color: AkyronTheme.cyanSpirit),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 240,
            child: Column(
              children: [
                StatBar(label: 'HP', value: s.hp, max: s.maxHp, color: AkyronTheme.crimsonAura),
                const SizedBox(height: 4),
                StatBar(label: 'MP', value: s.mp, max: s.maxMp, color: AkyronTheme.violetArcane),
                if (s.maxChakra > 0) ...[
                  const SizedBox(height: 4),
                  StatBar(label: 'CHAKRA', value: s.chakra, max: s.maxChakra, color: AkyronTheme.cyanSpirit),
                ],
                if (s.maxCursedEnergy > 0) ...[
                  const SizedBox(height: 4),
                  StatBar(label: 'CURSED', value: s.cursedEnergy, max: s.maxCursedEnergy, color: Color(0xFFB02FE0)),
                ],
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _HudButton(icon: Icons.shield, label: 'Equipar', onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EquipmentScreen(character: widget.character),
                ));
                setState(() {});
              }),
              const SizedBox(width: 8),
              _HudButton(icon: Icons.bolt, label: 'Treino', onTap: _startTrainingBattle),
              const SizedBox(width: 8),
              _HudButton(icon: Icons.menu_book, label: 'Códex', onTap: () {
                Navigator.of(context).pushNamed('/lore');
              }),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _startTrainingBattle() async {
    AudioDirector.instance.sfx(Sfx.uiClick);
    final result = await Navigator.of(context).push<int>(
      MaterialPageRoute(builder: (_) => CombatScreen(player: widget.character)),
    );
    // Ao voltar do combate, restaura mood da região.
    _applyExploreMood();
    if (result != null && result > 0) {
      final lvl = LevelingSystem.grantXp(widget.character, result);
      if (lvl.leveledUp) {
        AudioDirector.instance.sfx(Sfx.levelUp);
        setState(() => _pendingLevelUp = lvl);
      }
      setState(() {});
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
    );
  }
}

class _HudButton extends StatelessWidget {
  const _HudButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AkyronTheme.deepNight,
        foregroundColor: AkyronTheme.paperBeige,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AkyronTheme.goldEon, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Joystick virtual sobre o GameWidget para controle mobile.
class _MobileJoystickPad extends StatefulWidget {
  const _MobileJoystickPad({required this.game});
  final AkyronGame game;

  @override
  State<_MobileJoystickPad> createState() => _MobileJoystickPadState();
}

class _MobileJoystickPadState extends State<_MobileJoystickPad> {
  Offset? _origin;
  Offset _delta = Offset.zero;

  void _reset() {
    _origin = null;
    _delta = Offset.zero;
    widget.game.setMoveAxis(Vector2.zero());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      bottom: 24,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (d) => setState(() => _origin = d.localPosition),
        onPanUpdate: (d) {
          if (_origin == null) return;
          _delta = (d.localPosition - _origin!).clampMagnitudeTo(40);
          final norm = Offset(_delta.dx / 40, _delta.dy / 40);
          widget.game.setMoveAxis(Vector2(norm.dx, norm.dy));
          setState(() {});
        },
        onPanEnd: (_) => _reset(),
        onPanCancel: _reset,
        child: SizedBox(
          width: 120, height: 120,
          child: CustomPaint(painter: _JoystickPainter(_delta)),
        ),
      ),
    );
  }
}

class _JoystickPainter extends CustomPainter {
  _JoystickPainter(this.delta);
  final Offset delta;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 50, Paint()..color = Colors.black38);
    canvas.drawCircle(center, 50,
        Paint()..color = AkyronTheme.goldEon..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(center + delta, 22, Paint()..color = AkyronTheme.goldEon);
  }
  @override
  bool shouldRepaint(covariant _JoystickPainter old) => old.delta != delta;
}

extension on Offset {
  Offset clampMagnitudeTo(double max) {
    final d = distance;
    if (d <= max) return this;
    return this * (max / d);
  }
}
