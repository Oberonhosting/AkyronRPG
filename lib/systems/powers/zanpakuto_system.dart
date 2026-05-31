import '../../models/enums.dart';
import '../../models/stats.dart';
import 'power_base.dart';

/// Estados de liberação da espada.
enum ZanpakutoStage { sealed, shikai, bankai }

/// Zanpakutō — espada com espírito morador, inspirada em Bleach.
class ZanpakutoCore extends PowerCore {
  ZanpakutoCore({
    required Element element,
    required this.spiritName,
    required this.spiritPersonality,
    this.stage = ZanpakutoStage.sealed,
  }) : super(
          system: PowerSystem.zanpakuto,
          element: element,
          rarity: Rarity.rare,
        ) {
    _refreshVisual();
  }

  final String spiritName;        // ex.: "Tsukibarai"
  final String spiritPersonality; // ex.: "Sarcástica e protetora"
  ZanpakutoStage stage;

  /// Confiança do espírito 0..100. Sobe com diálogos certos e batalhas.
  int trust = 10;

  @override
  bool tryEvolve() {
    switch (stage) {
      case ZanpakutoStage.sealed:
        if (trust >= 50) {
          stage = ZanpakutoStage.shikai;
          formName = 'Shikai — $spiritName';
          _refreshVisual();
          return true;
        }
        return false;
      case ZanpakutoStage.shikai:
        if (trust >= 100) {
          stage = ZanpakutoStage.bankai;
          formName = 'BANKAI — $spiritName';
          _refreshVisual();
          return true;
        }
        return false;
      case ZanpakutoStage.bankai:
        return false;
    }
  }

  @override
  void onTurnStart(Stats owner) {
    // Bankai gasta vitalidade lentamente — preço da forma suprema.
    if (stage == ZanpakutoStage.bankai) {
      owner.hp = (owner.hp - (owner.maxHp * 0.02).round()).clamp(0, owner.maxHp);
    }
  }

  void _refreshVisual() {
    visualId = 'zanpakuto_${element.name}_${stage.name}';
  }

  /// Dica de diálogo do espírito durante combate.
  String? spiritWhisper(double hpRatio) {
    if (hpRatio < 0.25 && stage == ZanpakutoStage.sealed) {
      return '"$spiritName: você ainda não me chamou pelo nome certo..."';
    }
    if (stage == ZanpakutoStage.shikai && trust < 80) {
      return '"$spiritName: confia mais em mim. Eu não quebro."';
    }
    return null;
  }
}
