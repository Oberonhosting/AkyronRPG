/// Boss mundial — todos os jogadores online em um mundo público enfrentam
/// juntos. Stats compartilhados; HP drena conforme players atacam.
class WorldBoss {
  WorldBoss({
    required this.id,
    required this.name,
    required this.maxHp,
    required this.lore,
    required this.windowStart,
    required this.windowEnd,
  }) : hp = maxHp;

  final String id;
  final String name;
  final String lore;
  final int maxHp;
  final DateTime windowStart;
  final DateTime windowEnd;

  int hp;
  int participants = 0;

  double get pct => hp <= 0 ? 0 : hp / maxHp;
  bool get defeated => hp <= 0;

  bool get active {
    final now = DateTime.now();
    return now.isAfter(windowStart) && now.isBefore(windowEnd) && !defeated;
  }

  void damage(int amount) {
    hp = (hp - amount).clamp(0, maxHp);
  }
}

class WorldBossRegistry {
  WorldBossRegistry._();

  static final WorldBoss currentWeek = WorldBoss(
    id: 'wb.veiled_devourer',
    name: 'Devorador Velado',
    maxHp: 5_000_000,
    lore: 'Nasceu de uma das fendas da Fratura. Cada batida no peito '
        'rachado libera mais um pedaço do Éon original — e mais um Devorador.',
    windowStart: DateTime.now().subtract(const Duration(hours: 1)),
    windowEnd: DateTime.now().add(const Duration(days: 6)),
  );
}
