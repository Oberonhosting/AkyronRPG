/// Estado global compartilhado entre todos os jogadores conectados
/// (boss mundial, eventos, clima global).
class WorldState {
  WorldState({this.bossMaxHp = 5000000, String? bossName})
      : bossName = bossName ?? 'Devorador Velado',
        _bossHp = bossMaxHp;

  final int bossMaxHp;
  final String bossName;
  int _bossHp;
  int participants = 0;

  bool get bossDefeated => _bossHp <= 0;
  int get bossHp => _bossHp;

  void damageBoss(int dmg) {
    if (bossDefeated) return;
    _bossHp = (_bossHp - dmg).clamp(0, bossMaxHp);
  }

  Map<String, dynamic> bossSnapshot() => {
        'name': bossName,
        'hp': _bossHp,
        'max_hp': bossMaxHp,
        'pct': bossMaxHp == 0 ? 0 : _bossHp / bossMaxHp,
        'defeated': bossDefeated,
        'participants': participants,
      };

  void respawnBoss({int? newMaxHp, String? newName}) {
    _bossHp = newMaxHp ?? bossMaxHp;
  }
}
