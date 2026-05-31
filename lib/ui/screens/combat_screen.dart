import 'package:flutter/material.dart' hide Element;

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/theme.dart';
import '../../data/catalogs/ability_catalog.dart';
import '../../models/character.dart';
import '../../models/enums.dart';
import '../../systems/combat/combat_engine.dart';
import '../../systems/combat/combatant.dart';
import '../../systems/powers/grimoire_system.dart';
import '../../systems/powers/power_base.dart';
import '../widgets/battle_cry_overlay.dart';
import '../widgets/stat_bar.dart';

/// Tela de combate por turnos com overlay de battle-cry e log estilo
/// mangá. Recebe o personagem do jogador e gera um inimigo treino.
class CombatScreen extends StatefulWidget {
  const CombatScreen({super.key, required this.player});

  final Character player;

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late final Combatant _player = Combatant(
    source: widget.player,
    stats: widget.player.baseStats.copy(),
    power: widget.player.power,
    isPlayer: true,
  );
  late final Combatant _enemy = _generateEnemy();
  late final CombatEngine _engine = CombatEngine(
    party: [_player],
    enemies: [_enemy],
  );

  String? _currentCry;
  bool _currentCryUltimate = false;
  bool _busy = false;
  bool _awakeningFiredPlayer = false;
  bool _awakeningFiredEnemy = false;

  @override
  void initState() {
    super.initState();
    // Inimigo "Sombra de Treino" é um boss de tutorial — usa tema de boss.
    AudioDirector.instance.setMood(MusicMood.combatBoss);
  }

  Combatant _generateEnemy() {
    // Boss de treino simples: contraparte com elemento oposto.
    final enemyPower = GrimoireCore(element: Element.dark, leaves: 2);
    enemyPower.abilities.addAll([
      AbilityCatalog.byId('grim.dark.shadow_grip')!,
      AbilityCatalog.byId('grim.dark.devourer')!,
    ]);
    return Combatant(
      source: Character(
        playerId: widget.player.playerId,
        displayName: 'Sombra de Treino',
        appearance: widget.player.appearance,
        power: enemyPower,
      ),
      stats: widget.player.baseStats.copy()..hp = 180,
      power: enemyPower,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Combate')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.4,
                colors: [
                  AkyronTheme.crimsonAura.withOpacity(0.18),
                  Colors.black,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _enemyHeader(),
                const SizedBox(height: 16),
                _arenaSilhouettes(),
                const SizedBox(height: 16),
                _playerStatsPanel(),
                const SizedBox(height: 12),
                Expanded(child: _abilityList()),
                _logPanel(),
              ],
            ),
          ),
          if (_currentCry != null)
            BattleCryOverlay(text: _currentCry!, isUltimate: _currentCryUltimate),
        ],
      ),
    );
  }

  Widget _enemyHeader() {
    return Column(
      children: [
        Text(
          _enemy.displayName,
          style: const TextStyle(
            color: AkyronTheme.crimsonAura,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        StatBar(
          label: 'HP DO INIMIGO',
          value: _enemy.stats.hp,
          max: _enemy.stats.maxHp,
          color: AkyronTheme.crimsonAura,
          height: 16,
        ),
      ],
    );
  }

  Widget _arenaSilhouettes() {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.person,
              size: 96,
              color: AkyronTheme.systemAura[widget.player.power.system.auraKey]),
          const Text('VS',
              style: TextStyle(
                color: AkyronTheme.goldEon,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              )),
          const Icon(Icons.bug_report, size: 96, color: AkyronTheme.crimsonAura),
        ],
      ),
    );
  }

  Widget _playerStatsPanel() {
    return Column(
      children: [
        StatBar(
          label: widget.player.displayName.toUpperCase(),
          value: _player.stats.hp,
          max: _player.stats.maxHp,
          color: AkyronTheme.cyanSpirit,
        ),
        const SizedBox(height: 4),
        StatBar(
          label: 'MP',
          value: _player.stats.mp,
          max: _player.stats.maxMp,
          color: AkyronTheme.violetArcane,
        ),
      ],
    );
  }

  Widget _abilityList() {
    final abilities = _player.power?.abilities ?? const <Ability>[];
    if (abilities.isEmpty) {
      return const Center(child: Text('Nenhuma habilidade equipada.'));
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: abilities.length,
      itemBuilder: (ctx, i) {
        final a = abilities[i];
        final cd = _player.cooldowns[a.id] ?? 0;
        return FilledButton(
          onPressed: _busy || cd > 0 ? null : () => _cast(a),
          style: FilledButton.styleFrom(
            backgroundColor: a.isUltimate
                ? AkyronTheme.goldEon
                : AkyronTheme.violetArcane,
            foregroundColor:
                a.isUltimate ? AkyronTheme.obsidian : Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(a.name, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 2),
              Text(
                'MP:${a.mpCost}'
                '${a.chakraCost > 0 ? ' CK:${a.chakraCost}' : ''}'
                '${a.cursedCost > 0 ? ' CE:${a.cursedCost}' : ''}'
                '${cd > 0 ? '  (cd $cd)' : ''}',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _logPanel() {
    final lines = _engine.log.reversed.take(4).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(color: AkyronTheme.goldEon, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final l in lines)
            Text(l, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Future<void> _cast(Ability a) async {
    setState(() {
      _busy = true;
      _currentCry = a.battleCry.isEmpty ? a.name : a.battleCry;
      _currentCryUltimate = a.isUltimate;
    });
    // Stinger e SFX por tipo de habilidade.
    if (a.isUltimate) {
      AudioDirector.instance.playStinger(_ultimateStingerFor(a));
      AudioDirector.instance.sfx(Sfx.spellCastHigh);
    } else if (a.basePower >= 60) {
      AudioDirector.instance.sfx(Sfx.spellCastMid);
    } else {
      AudioDirector.instance.sfx(_sfxForAbility(a));
    }

    await _engine.playerAction(actor: _player, ability: a, target: _enemy);
    _maybePlayAwakeningSting();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _currentCry = null);

    if (_engine.finished) {
      _finish();
      return;
    }

    await _engine.enemyTurn();
    _maybePlayAwakeningSting();
    if (!mounted) return;
    setState(() => _busy = false);

    if (_engine.finished) _finish();
  }

  /// Escolhe o stinger de ultimate baseado no sistema do conjurador.
  MusicMood _ultimateStingerFor(Ability a) {
    if (a.system == PowerSystem.zanpakuto) return MusicMood.cutsceneBankai;
    if (a.system == PowerSystem.cursed) return MusicMood.cutsceneDomain;
    return MusicMood.ultimate;
  }

  Sfx _sfxForAbility(Ability a) {
    return switch (a.system) {
      PowerSystem.zanpakuto => Sfx.swordSlash,
      PowerSystem.breathing => Sfx.swordSlash,
      PowerSystem.cursed => Sfx.punchHit,
      _ => Sfx.spellCastLow,
    };
  }

  void _maybePlayAwakeningSting() {
    if (!_awakeningFiredPlayer && _player.awakened) {
      _awakeningFiredPlayer = true;
      AudioDirector.instance.playStinger(MusicMood.awakening);
      AudioDirector.instance.sfx(Sfx.awakeningFlash);
    }
    if (!_awakeningFiredEnemy && _enemy.awakened) {
      _awakeningFiredEnemy = true;
      AudioDirector.instance.sfx(Sfx.cursedHum);
    }
  }

  void _finish() {
    final r = _engine.buildResult();
    AudioDirector.instance.playStinger(
      r.victory ? MusicMood.victory : MusicMood.defeat,
    );
    if (r.victory) {
      AudioDirector.instance.sfx(Sfx.enemyDie);
    }
    Future.microtask(() {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(r.victory ? 'VITÓRIA' : 'DERROTA'),
          content: Text(r.victory
              ? 'Você ganhou ${r.xpGained} XP e ${r.coinsGained} moedas.'
              : 'O treino te quebrou. Reanimando na vila...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, r.xpGained);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}
