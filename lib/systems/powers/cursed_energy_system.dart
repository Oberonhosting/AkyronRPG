import '../../models/enums.dart';
import '../../models/stats.dart';
import 'power_base.dart';

/// Energia Amaldiçoada — sistema inspirado em Jujutsu Kaisen.
class CursedEnergyCore extends PowerCore {
  CursedEnergyCore({
    required this.innateTechnique,
    required Element element,
  }) : super(
          system: PowerSystem.cursed,
          element: element,
          rarity: Rarity.epic,
        ) {
    formName = innateTechnique;
    visualId = 'cursed_${element.name}';
  }

  /// Técnica Inata única do feiticeiro (nome próprio que o jogo gera).
  final String innateTechnique;

  /// Expansão de Território disponível?
  bool domainUnlocked = false;

  /// Cooldown da Expansão (em turnos).
  int domainCooldown = 0;

  /// O usuário pode usar Inversão de Energia Amaldiçoada para se curar.
  /// É arriscado — cura significativa, mas gasta o dobro de CE.
  bool reverseCursedTechnique = false;

  @override
  bool tryEvolve() {
    if (!domainUnlocked) {
      domainUnlocked = true;
      return true;
    }
    if (!reverseCursedTechnique) {
      reverseCursedTechnique = true;
      return true;
    }
    return false;
  }

  /// Cura via inversão. Retorna quanto curou (0 se não pôde).
  int reverseHeal(Stats s, int amount) {
    if (!reverseCursedTechnique) return 0;
    final cost = amount * 2;
    if (s.cursedEnergy < cost) return 0;
    s.cursedEnergy -= cost;
    final actual = (s.hp + amount).clamp(0, s.maxHp) - s.hp;
    s.hp += actual;
    return actual;
  }

  @override
  void onTurnStart(Stats owner) {
    if (domainCooldown > 0) domainCooldown--;
  }
}
