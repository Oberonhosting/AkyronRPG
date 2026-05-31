import '../../core/constants.dart';
import '../../models/character.dart';
import '../../models/enums.dart';

/// Resultado de aplicar XP — usado para overlay dramático.
class LevelUpResult {
  LevelUpResult({
    required this.leveledUp,
    required this.newLevel,
    required this.newRank,
    required this.statBonuses,
  });

  final bool leveledUp;
  final int newLevel;
  final Rank newRank;
  final Map<String, int> statBonuses;
}

class LevelingSystem {
  LevelingSystem._();

  /// Curva: 100 * level^1.6 — sobe progressivamente.
  static int xpToNext(int level) {
    return (100 * (level * level * 0.0265 + level * 0.85 + 1)).round();
  }

  static LevelUpResult grantXp(Character c, int amount) {
    var leveled = false;
    final bonuses = <String, int>{
      'hp': 0, 'mp': 0, 'atk': 0, 'def': 0, 'spi': 0, 'res': 0, 'spd': 0,
    };

    c.xp += amount;
    while (c.level < AkyronK.maxLevel && c.xp >= xpToNext(c.level)) {
      c.xp -= xpToNext(c.level);
      c.level++;
      leveled = true;
      // Bônus por sistema.
      switch (c.power.system) {
        case PowerSystem.grimoire:
          c.baseStats.maxMp += 12; bonuses['mp'] = bonuses['mp']! + 12;
          c.baseStats.spirit += 3; bonuses['spi'] = bonuses['spi']! + 3;
          c.baseStats.maxHp += 5; bonuses['hp'] = bonuses['hp']! + 5;
          break;
        case PowerSystem.zanpakuto:
          c.baseStats.attack += 3; bonuses['atk'] = bonuses['atk']! + 3;
          c.baseStats.maxHp += 9; bonuses['hp'] = bonuses['hp']! + 9;
          c.baseStats.crit += 1;
          break;
        case PowerSystem.chakra:
          c.baseStats.maxChakra += 8; bonuses['mp'] = bonuses['mp']! + 8;
          c.baseStats.speed += 1; bonuses['spd'] = bonuses['spd']! + 1;
          c.baseStats.maxHp += 7; bonuses['hp'] = bonuses['hp']! + 7;
          break;
        case PowerSystem.breathing:
          c.baseStats.attack += 2; bonuses['atk'] = bonuses['atk']! + 2;
          c.baseStats.speed += 2; bonuses['spd'] = bonuses['spd']! + 2;
          c.baseStats.maxHp += 7; bonuses['hp'] = bonuses['hp']! + 7;
          break;
        case PowerSystem.nen:
          c.baseStats.spirit += 2; bonuses['spi'] = bonuses['spi']! + 2;
          c.baseStats.attack += 2; bonuses['atk'] = bonuses['atk']! + 2;
          c.baseStats.maxMp += 8; bonuses['mp'] = bonuses['mp']! + 8;
          c.baseStats.maxHp += 6; bonuses['hp'] = bonuses['hp']! + 6;
          break;
        case PowerSystem.cursed:
          c.baseStats.maxCursedEnergy += 8;
          c.baseStats.attack += 2; bonuses['atk'] = bonuses['atk']! + 2;
          c.baseStats.maxHp += 7; bonuses['hp'] = bonuses['hp']! + 7;
          break;
      }
      c.baseStats.hp = c.baseStats.maxHp;
      c.baseStats.mp = c.baseStats.maxMp;
      c.baseStats.chakra = c.baseStats.maxChakra;
      c.baseStats.cursedEnergy = c.baseStats.maxCursedEnergy;
    }

    c.rank = RankSystem.fromLevel(c.level);

    return LevelUpResult(
      leveledUp: leveled,
      newLevel: c.level,
      newRank: c.rank,
      statBonuses: bonuses,
    );
  }
}

class RankSystem {
  RankSystem._();

  static Rank fromLevel(int level) {
    if (level < 10) return Rank.d;
    if (level < 25) return Rank.c;
    if (level < 40) return Rank.b;
    if (level < 60) return Rank.a;
    if (level < 80) return Rank.s;
    if (level < 100) return Rank.ss;
    if (level < 119) return Rank.legendary;
    return Rank.transcendent;
  }
}
