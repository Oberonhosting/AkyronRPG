import '../../models/character.dart';
import '../../models/enums.dart';
import '../../models/stats.dart';
import '../powers/power_base.dart';
import 'status_effects.dart';

/// Wrapper de Character durante uma batalha — carrega stats efetivos,
/// statuses ativos, contadores de cooldown e flag de despertar.
class Combatant {
  Combatant({
    required this.source,
    required this.stats,
    required this.power,
    this.isPlayer = false,
    this.isBoss = false,
  });

  /// Personagem original. Pode ser null para inimigos genéricos.
  final Character? source;

  /// Stats efetivos (cópia mutável para esta batalha).
  Stats stats;

  /// Núcleo de poder (pode ser null para inimigos com habilidades fixas).
  PowerCore? power;

  bool isPlayer;
  bool isBoss;
  bool awakened = false;
  int comboCount = 0;
  DateTime? lastActionAt;

  final Map<String, int> cooldowns = {};
  final List<ActiveStatus> statuses = [];

  String get displayName => source?.displayName ?? 'Inimigo';

  bool get isAlive => !stats.isDead;

  void addStatus(ActiveStatus s) {
    final exists = statuses.firstWhere(
      (e) => e.effect == s.effect,
      orElse: () => ActiveStatus(effect: s.effect, duration: -1),
    );
    if (exists.duration <= 0) {
      statuses.add(s);
    } else {
      // Renova duração e magnitude.
      exists.duration = s.duration;
      exists.magnitude = s.magnitude;
    }
  }

  void tickCooldowns() {
    final keys = cooldowns.keys.toList();
    for (final k in keys) {
      final v = cooldowns[k]! - 1;
      if (v <= 0) {
        cooldowns.remove(k);
      } else {
        cooldowns[k] = v;
      }
    }
  }

  void tickStatuses(List<String> log) {
    for (final s in List.of(statuses)) {
      final msg = StatusResolver.tick(s, stats);
      if (msg != null) log.add('$displayName: $msg');
      if (s.expired) statuses.remove(s);
    }
  }

  bool canAct() => !StatusResolver.blocksAction(statuses) && isAlive;
  bool canCast() => !StatusResolver.blocksSpell(statuses);
}
