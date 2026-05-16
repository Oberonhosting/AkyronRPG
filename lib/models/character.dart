import 'package:uuid/uuid.dart';

import '../core/id_generator.dart';
import '../systems/powers/breathing_system.dart';
import '../systems/powers/chakra_system.dart';
import '../systems/powers/cursed_energy_system.dart';
import '../systems/powers/grimoire_system.dart';
import '../systems/powers/nen_system.dart';
import '../systems/powers/power_base.dart';
import '../systems/powers/zanpakuto_system.dart';
import 'appearance.dart';
import 'enums.dart';
import 'equipment.dart';
import 'inventory.dart';
import 'stats.dart';

/// Personagem do jogador (também usado para party members / NPCs).
class Character {
  Character({
    String? uuid,
    required this.playerId,
    required this.displayName,
    required this.appearance,
    required this.power,
    Stats? baseStats,
    Loadout? loadout,
    Inventory? inventory,
    this.level = 1,
    this.xp = 0,
    this.rank = Rank.d,
    this.coins = 0,
    this.title = '',
    this.region = 'region.starthorn',
  })  : id = uuid ?? const Uuid().v4(),
        baseStats = baseStats ?? _defaultStats(power.system),
        loadout = loadout ?? Loadout(),
        inventory = inventory ?? Inventory();

  /// UUID interno (banco). Diferente do PlayerId público.
  final String id;

  /// ID público #Yami4521 — visível para outros jogadores.
  PlayerId playerId;

  String displayName;
  Appearance appearance;

  /// Núcleo de poder atual (um dos seis sistemas).
  PowerCore power;

  /// Stats base (sem bônus de roupas).
  Stats baseStats;

  Loadout loadout;
  Inventory inventory;

  int level;
  int xp;
  Rank rank;
  int coins;
  String title;     // ex: "Despertador da Chama-Violeta"
  String region;    // id da região atual

  /// Stats efetivos = base + bônus de loadout.
  Stats effectiveStats(List<SetBonus> registry) {
    final s = baseStats.copy();
    s.addBonuses(loadout.computeBonus(registry));
    return s;
  }

  static Stats _defaultStats(PowerSystem sys) => switch (sys) {
        PowerSystem.grimoire => Stats(
            maxHp: 95, hp: 95, maxMp: 140, mp: 140,
            attack: 8, defense: 7, spirit: 16, resist: 12, speed: 9, focus: 14,
          ),
        PowerSystem.zanpakuto => Stats(
            maxHp: 115, hp: 115, maxMp: 60, mp: 60,
            attack: 16, defense: 12, spirit: 9, resist: 9, speed: 12, crit: 7,
          ),
        PowerSystem.chakra => Stats(
            maxHp: 105, hp: 105, maxMp: 70, mp: 70,
            maxChakra: 120, chakra: 120,
            attack: 12, defense: 9, spirit: 11, resist: 9, speed: 13, focus: 10,
          ),
        PowerSystem.breathing => Stats(
            maxHp: 110, hp: 110, maxMp: 60, mp: 60,
            attack: 15, defense: 10, spirit: 8, resist: 8, speed: 16, crit: 9,
          ),
        PowerSystem.nen => Stats(
            maxHp: 100, hp: 100, maxMp: 100, mp: 100,
            attack: 11, defense: 9, spirit: 12, resist: 10, speed: 11, focus: 12,
          ),
        PowerSystem.cursed => Stats(
            maxHp: 105, hp: 105, maxMp: 40, mp: 40,
            maxCursedEnergy: 100, cursedEnergy: 100,
            attack: 14, defense: 9, spirit: 12, resist: 9, speed: 11, focus: 11,
          ),
      };

  // ───────────────────────── Serialização ─────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'pid': playerId.formatted,
        'name': displayName,
        'appearance': appearance.toJson(),
        'power': power.toJson(),
        'baseStats': baseStats.toJson(),
        'loadout': loadout.toJson(),
        'inventory': inventory.toJson(),
        'level': level, 'xp': xp,
        'rank': rank.name, 'coins': coins,
        'title': title, 'region': region,
      };

  /// Reidrata o núcleo de poder a partir do JSON salvo. Sistemas mais
  /// complexos podem requerer dados extras (ex.: nome do espírito) — aqui
  /// vamos com defaults razoáveis e o save real estende.
  static PowerCore powerFromJson(Map<String, dynamic> j) {
    final sys = PowerSystem.values.firstWhere((s) => s.name == j['system']);
    final el = Element.values.firstWhere((e) => e.name == j['element']);
    switch (sys) {
      case PowerSystem.grimoire:
        return GrimoireCore(element: el, leaves: 3);
      case PowerSystem.zanpakuto:
        return ZanpakutoCore(
          element: el,
          spiritName: 'Tsukibarai',
          spiritPersonality: 'Sarcástica e protetora',
        );
      case PowerSystem.chakra:
        return ChakraCore(element: el);
      case PowerSystem.breathing:
        return BreathingCore(style: BreathingStyle.water);
      case PowerSystem.nen:
        return NenCore(type: NenType.enhancement, element: el);
      case PowerSystem.cursed:
        return CursedEnergyCore(
          innateTechnique: 'Caminho do Vazio Curto',
          element: el,
        );
    }
  }
}
