import '../../models/enums.dart';
import 'power_base.dart';

/// Estilos de respiração canônicos.
enum BreathingStyle { water, flame, thunder, stone, wind, mist, sun }

extension BreathingStyleX on BreathingStyle {
  String get label => switch (this) {
        BreathingStyle.water => 'Respiração da Água',
        BreathingStyle.flame => 'Respiração da Chama',
        BreathingStyle.thunder => 'Respiração do Trovão',
        BreathingStyle.stone => 'Respiração da Pedra',
        BreathingStyle.wind => 'Respiração do Vento',
        BreathingStyle.mist => 'Respiração da Bruma',
        BreathingStyle.sun => 'Respiração do Sol',
      };

  Element get element => switch (this) {
        BreathingStyle.water => Element.water,
        BreathingStyle.flame => Element.fire,
        BreathingStyle.thunder => Element.lightning,
        BreathingStyle.stone => Element.earth,
        BreathingStyle.wind => Element.wind,
        BreathingStyle.mist => Element.ice,
        BreathingStyle.sun => Element.light,
      };
}

/// Respirações — Demon Slayer-style. Formas numeradas com nomes próprios.
class BreathingCore extends PowerCore {
  BreathingCore({required this.style})
      : super(
          system: PowerSystem.breathing,
          element: style.element,
          rarity: Rarity.common,
        ) {
    formName = style.label;
    visualId = 'breathing_${style.name}';
  }

  final BreathingStyle style;

  /// Maestria 0..1000. Sobe a cada uso de forma.
  int mastery = 0;

  /// Forma máxima desbloqueada (1..10). Formas Superiores são 8+.
  int unlockedFormNumber = 3;

  @override
  bool tryEvolve() {
    final next = switch (mastery) {
      < 100 => 3,
      < 250 => 4,
      < 500 => 6,
      < 800 => 8,
      _ => 10,
    };
    if (next > unlockedFormNumber) {
      unlockedFormNumber = next;
      return true;
    }
    return false;
  }

  /// Registra uso e tenta evoluir.
  bool train(int xp) {
    mastery = (mastery + xp).clamp(0, 1000);
    return tryEvolve();
  }
}
