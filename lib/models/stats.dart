import 'dart:math';

/// Atributos base do personagem.
class Stats {
  Stats({
    this.hp = 100,
    this.maxHp = 100,
    this.mp = 50,
    this.maxMp = 50,
    this.chakra = 0,
    this.maxChakra = 0,
    this.cursedEnergy = 0,
    this.maxCursedEnergy = 0,
    this.attack = 10,
    this.defense = 8,
    this.spirit = 10,
    this.resist = 8,
    this.speed = 10,
    this.crit = 5,
    this.evasion = 5,
    this.focus = 10,
  });

  int hp, maxHp;
  int mp, maxMp;
  int chakra, maxChakra;       // Naruto-style.
  int cursedEnergy, maxCursedEnergy; // JJK.

  int attack, defense;
  int spirit, resist;          // Mágico.
  int speed;                   // Ordem dos turnos.
  int crit;                    // % crítico.
  int evasion;                 // % esquiva.
  int focus;                   // Pontaria de habilidade.

  double get hpRatio => maxHp == 0 ? 0 : hp / maxHp;
  double get mpRatio => maxMp == 0 ? 0 : mp / maxMp;

  bool get isDead => hp <= 0;

  void clamp() {
    hp = hp.clamp(0, maxHp);
    mp = mp.clamp(0, maxMp);
    chakra = chakra.clamp(0, maxChakra);
    cursedEnergy = cursedEnergy.clamp(0, maxCursedEnergy);
  }

  /// Soma outro bloco de stats neste (usado para aplicar bônus de roupa).
  void addBonuses(Stats b) {
    maxHp += b.maxHp;
    maxMp += b.maxMp;
    maxChakra += b.maxChakra;
    maxCursedEnergy += b.maxCursedEnergy;
    attack += b.attack;
    defense += b.defense;
    spirit += b.spirit;
    resist += b.resist;
    speed += b.speed;
    crit += b.crit;
    evasion += b.evasion;
    focus += b.focus;
    hp = min(hp, maxHp);
    mp = min(mp, maxMp);
  }

  Stats copy() => Stats(
        hp: hp, maxHp: maxHp,
        mp: mp, maxMp: maxMp,
        chakra: chakra, maxChakra: maxChakra,
        cursedEnergy: cursedEnergy, maxCursedEnergy: maxCursedEnergy,
        attack: attack, defense: defense,
        spirit: spirit, resist: resist,
        speed: speed, crit: crit,
        evasion: evasion, focus: focus,
      );

  Map<String, dynamic> toJson() => {
        'hp': hp, 'maxHp': maxHp,
        'mp': mp, 'maxMp': maxMp,
        'chakra': chakra, 'maxChakra': maxChakra,
        'ce': cursedEnergy, 'maxCe': maxCursedEnergy,
        'atk': attack, 'def': defense,
        'spi': spirit, 'res': resist,
        'spd': speed, 'crit': crit,
        'eva': evasion, 'foc': focus,
      };

  factory Stats.fromJson(Map<String, dynamic> j) => Stats(
        hp: j['hp'] ?? 100,
        maxHp: j['maxHp'] ?? 100,
        mp: j['mp'] ?? 50,
        maxMp: j['maxMp'] ?? 50,
        chakra: j['chakra'] ?? 0,
        maxChakra: j['maxChakra'] ?? 0,
        cursedEnergy: j['ce'] ?? 0,
        maxCursedEnergy: j['maxCe'] ?? 0,
        attack: j['atk'] ?? 10,
        defense: j['def'] ?? 8,
        spirit: j['spi'] ?? 10,
        resist: j['res'] ?? 8,
        speed: j['spd'] ?? 10,
        crit: j['crit'] ?? 5,
        evasion: j['eva'] ?? 5,
        focus: j['foc'] ?? 10,
      );
}
