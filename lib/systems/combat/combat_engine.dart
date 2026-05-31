import 'dart:async';
import 'dart:math';

import '../../core/constants.dart';
import '../../models/enums.dart';
import '../powers/power_base.dart';
import 'combatant.dart';
import 'status_effects.dart';

/// Resultado de uma única ação no combate.
class CombatEvent {
  CombatEvent({
    required this.actor,
    required this.message,
    required this.battleCry,
    this.target,
    this.damage = 0,
    this.healed = 0,
    this.isUltimate = false,
    this.statusesApplied = const [],
  });

  final Combatant actor;
  final Combatant? target;
  final String message;
  final String battleCry;
  final int damage;
  final int healed;
  final bool isUltimate;
  final List<StatusEffect> statusesApplied;
}

/// Resultado final de uma batalha.
class BattleResult {
  BattleResult({
    required this.victory,
    required this.xpGained,
    required this.coinsGained,
    required this.loot,
    required this.log,
  });

  final bool victory;
  final int xpGained;
  final int coinsGained;
  final List<String> loot; // ids de itens
  final List<String> log;
}

/// Motor central de combate por turnos.
///
/// Estilo:
/// - Iniciativa: stats.speed + um pequeno random.
/// - Combos: ações em sequência dentro de [comboWindowMs] aumentam dano.
/// - Despertar: cruzar o HP threshold → modo desperto automático.
/// - Ultimate: ação especial com efeito cinemático (sinalizado pelo
///   stream).
class CombatEngine {
  CombatEngine({
    required this.party,
    required this.enemies,
    Random? rng,
  }) : _rng = rng ?? Random();

  final List<Combatant> party;
  final List<Combatant> enemies;
  final Random _rng;

  final _events = StreamController<CombatEvent>.broadcast();
  Stream<CombatEvent> get events => _events.stream;

  final List<String> log = [];
  int round = 0;
  bool finished = false;

  /// Executa um turno do jogador. Retorna o evento gerado.
  Future<CombatEvent> playerAction({
    required Combatant actor,
    required Ability ability,
    required Combatant target,
  }) async {
    if (finished) {
      return _miss(actor, 'Combate já terminou.');
    }
    if (!actor.canAct()) {
      return _miss(actor, '${actor.displayName} está impedido!');
    }
    if (ability.mpCost > 0 && !actor.canCast()) {
      return _miss(actor, '${actor.displayName} está silenciado!');
    }
    final power = actor.power;
    if (power != null && !power.canPay(ability, actor.stats)) {
      return _miss(actor, 'Energia insuficiente para ${ability.name}.');
    }
    if ((actor.cooldowns[ability.id] ?? 0) > 0) {
      return _miss(actor, '${ability.name} em recarga.');
    }
    if (power != null) power.pay(ability, actor.stats);
    if (ability.cooldownTurns > 0) {
      actor.cooldowns[ability.id] = ability.cooldownTurns;
    }

    final ev = _resolve(actor, ability, target);
    _events.add(ev);
    log.add(ev.message);

    _maybeAwaken(actor);
    _checkEnd();
    return ev;
  }

  /// Roda os turnos dos inimigos. Chamado depois que o jogador agiu.
  Future<void> enemyTurn() async {
    if (finished) return;
    for (final e in enemies.where((c) => c.isAlive)) {
      if (!e.canAct()) {
        e.tickStatuses(log);
        continue;
      }
      // IA simples: escolhe uma habilidade aleatória que pode pagar.
      final usable = (e.power?.abilities ?? const [])
          .where((a) => e.power!.canPay(a, e.stats))
          .toList();
      final ability = usable.isEmpty
          ? const Ability(
              id: 'basic.strike',
              name: 'Ataque Básico',
              system: PowerSystem.zanpakuto,
              element: Element.dark,
              rarity: Rarity.common,
              basePower: 14, mpCost: 0,
              battleCry: '...',
            )
          : usable[_rng.nextInt(usable.length)];

      final aliveAllies = party.where((p) => p.isAlive).toList();
      if (aliveAllies.isEmpty) break;
      final target = aliveAllies[_rng.nextInt(aliveAllies.length)];

      if (e.power != null) e.power!.pay(ability, e.stats);
      final ev = _resolve(e, ability, target);
      _events.add(ev);
      log.add(ev.message);
      _maybeAwaken(e);
      e.tickStatuses(log);
      e.tickCooldowns();
      if (_checkEnd()) return;
    }
    round++;
    for (final p in party) {
      p.tickStatuses(log);
      p.tickCooldowns();
      p.power?.onTurnStart(p.stats);
    }
  }

  CombatEvent _resolve(Combatant actor, Ability a, Combatant target) {
    // Despertar dá +30% de dano.
    final mult = actor.awakened ? 1.3 : 1.0;
    // Combos somam +10% por hit recente (cap 50%).
    final comboMult = 1.0 + min(0.5, actor.comboCount * 0.1);
    final critRoll = _rng.nextInt(100) < actor.stats.crit;
    final critMult = critRoll ? 1.7 : 1.0;

    int dmg = (a.computeDamage(actor.stats, target.stats) *
            mult *
            comboMult *
            critMult)
        .round();

    // Esquiva.
    final evaded = _rng.nextInt(100) < target.stats.evasion;
    if (evaded) dmg = 0;

    if (dmg > 0) {
      target.stats.hp -= dmg;
      target.stats.clamp();
    }

    // Aplica status.
    final applied = <StatusEffect>[];
    if (dmg > 0) {
      for (final s in a.statuses) {
        target.addStatus(ActiveStatus(effect: s, duration: 3));
        applied.add(s);
      }
    }

    // Combo tracking.
    final now = DateTime.now();
    if (actor.lastActionAt != null &&
        now.difference(actor.lastActionAt!).inMilliseconds <
            AkyronK.comboWindowMs) {
      actor.comboCount++;
    } else {
      actor.comboCount = 0;
    }
    actor.lastActionAt = now;

    String message;
    if (evaded) {
      message = '${actor.displayName} usou ${a.name} — ${target.displayName} esquivou!';
    } else if (critRoll && dmg > 0) {
      message = '${actor.displayName} usou ${a.name} — CRÍTICO! ${dmg} de dano em ${target.displayName}.';
    } else if (dmg > 0) {
      message = '${actor.displayName} usou ${a.name} — ${dmg} de dano em ${target.displayName}.';
    } else {
      message = '${actor.displayName} usou ${a.name}.';
    }

    return CombatEvent(
      actor: actor,
      target: target,
      message: message,
      battleCry: a.battleCry.isEmpty ? a.name : a.battleCry,
      damage: dmg,
      isUltimate: a.isUltimate,
      statusesApplied: applied,
    );
  }

  CombatEvent _miss(Combatant actor, String reason) {
    final ev = CombatEvent(
      actor: actor,
      message: reason,
      battleCry: '...',
    );
    _events.add(ev);
    log.add(reason);
    return ev;
  }

  void _maybeAwaken(Combatant c) {
    if (c.awakened) return;
    if (c.stats.hpRatio * 100 <= AkyronK.awakeningHpThresholdPct) {
      c.awakened = true;
      c.addStatus(
        ActiveStatus(effect: StatusEffect.awakened, duration: 99),
      );
      final msg = '✦ ${c.displayName} DESPERTOU! ✦';
      log.add(msg);
      _events.add(CombatEvent(
        actor: c,
        message: msg,
        battleCry: 'DESPERTAR!',
        isUltimate: true,
      ));
    }
  }

  bool _checkEnd() {
    final allEnemiesDown = enemies.every((c) => !c.isAlive);
    final allPlayersDown = party.every((c) => !c.isAlive);
    if (allEnemiesDown || allPlayersDown) {
      finished = true;
      return true;
    }
    return false;
  }

  BattleResult buildResult() {
    final victory = enemies.every((c) => !c.isAlive);
    final xp = victory ? enemies.length * 35 + round * 3 : 0;
    final coins = victory ? enemies.length * 22 : 0;
    final loot = <String>[];
    if (victory) {
      // 12% de chance por inimigo derrotado de dropar item raro+.
      for (var i = 0; i < enemies.length; i++) {
        if (_rng.nextInt(100) < 12) loot.add('top.runic_shirt');
      }
    }
    return BattleResult(
      victory: victory,
      xpGained: xp,
      coinsGained: coins,
      loot: loot,
      log: List.unmodifiable(log),
    );
  }

  void dispose() {
    _events.close();
  }
}
