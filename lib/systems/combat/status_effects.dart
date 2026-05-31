import '../../models/enums.dart';
import '../../models/stats.dart';

/// Efeito de status ativo em um combatente.
class ActiveStatus {
  ActiveStatus({
    required this.effect,
    required this.duration,
    this.magnitude = 0,
  });

  final StatusEffect effect;
  int duration;
  int magnitude;

  bool get expired => duration <= 0;
}

class StatusResolver {
  StatusResolver._();

  /// Aplica o tick de um status no dono. Retorna mensagem para log.
  static String? tick(ActiveStatus s, Stats owner) {
    switch (s.effect) {
      case StatusEffect.burn:
        final dmg = (owner.maxHp * 0.05).round();
        owner.hp -= dmg;
        owner.clamp();
        s.duration--;
        return 'Queimadura tira $dmg de HP.';
      case StatusEffect.poison:
        final dmg = (owner.maxHp * 0.03).round();
        owner.hp -= dmg;
        owner.clamp();
        s.duration--;
        return 'Veneno tira $dmg de HP.';
      case StatusEffect.bleed:
        final dmg = (owner.maxHp * 0.04).round();
        owner.hp -= dmg;
        owner.clamp();
        s.duration--;
        return 'Sangramento tira $dmg de HP.';
      case StatusEffect.regen:
        final heal = (owner.maxHp * 0.05).round();
        owner.hp = (owner.hp + heal).clamp(0, owner.maxHp);
        s.duration--;
        return 'Regeneração cura $heal de HP.';
      case StatusEffect.paralysis:
      case StatusEffect.freeze:
      case StatusEffect.stun:
      case StatusEffect.silence:
        s.duration--;
        return null;
      case StatusEffect.haste:
      case StatusEffect.shield:
      case StatusEffect.awakened:
        s.duration--;
        return null;
      case StatusEffect.curse:
        // 50% de chance de pular turno; gerenciado em TurnManager.
        s.duration--;
        return null;
    }
  }

  static bool blocksAction(List<ActiveStatus> list) {
    return list.any((s) =>
        s.effect == StatusEffect.paralysis ||
        s.effect == StatusEffect.freeze ||
        s.effect == StatusEffect.stun);
  }

  static bool blocksSpell(List<ActiveStatus> list) {
    return list.any((s) => s.effect == StatusEffect.silence);
  }
}
