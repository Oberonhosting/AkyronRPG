import '../../models/enums.dart';
import '../../models/stats.dart';
import 'power_base.dart';

/// Modos especiais que ativam transformação visual completa.
enum ChakraMode { base, sage, mantleV1, mantleV2, sixPaths }

extension ChakraModeX on ChakraMode {
  String get label => switch (this) {
        ChakraMode.base => 'Forma Base',
        ChakraMode.sage => 'Modo Sábio',
        ChakraMode.mantleV1 => 'Manto V1',
        ChakraMode.mantleV2 => 'Manto V2',
        ChakraMode.sixPaths => 'Modo Seis Caminhos',
      };
}

/// Chakra — sistema inspirado em Naruto.
class ChakraCore extends PowerCore {
  ChakraCore({required Element element})
      : super(
          system: PowerSystem.chakra,
          element: element,
          rarity: Rarity.common,
        ) {
    _refreshVisual();
  }

  ChakraMode mode = ChakraMode.base;

  /// Cooldown em turnos antes de poder trocar de modo novamente.
  int modeCooldown = 0;

  @override
  bool tryEvolve() {
    // Promove ao próximo modo se o jogador atingiu marco.
    final next = switch (mode) {
      ChakraMode.base => ChakraMode.sage,
      ChakraMode.sage => ChakraMode.mantleV1,
      ChakraMode.mantleV1 => ChakraMode.mantleV2,
      ChakraMode.mantleV2 => ChakraMode.sixPaths,
      ChakraMode.sixPaths => null,
    };
    if (next == null) return false;
    mode = next;
    formName = next.label;
    _refreshVisual();
    return true;
  }

  @override
  void onTurnStart(Stats owner) {
    if (modeCooldown > 0) modeCooldown--;
    // Modo Sábio regenera chakra; mantos consomem HP em troca de poder.
    switch (mode) {
      case ChakraMode.sage:
        owner.chakra = (owner.chakra + 8).clamp(0, owner.maxChakra);
        break;
      case ChakraMode.mantleV1:
        owner.hp -= (owner.maxHp * 0.01).round();
        break;
      case ChakraMode.mantleV2:
        owner.hp -= (owner.maxHp * 0.03).round();
        break;
      case ChakraMode.sixPaths:
        owner.chakra = (owner.chakra + 15).clamp(0, owner.maxChakra);
        owner.mp = (owner.mp + 10).clamp(0, owner.maxMp);
        break;
      case ChakraMode.base:
        break;
    }
    owner.clamp();
  }

  /// Selo manual exigido antes da técnica (animação de selos).
  List<String> handSealsFor(Ability a) {
    // Cada elemento + power dão uma sequência distinta.
    final seq = <String>[];
    switch (a.element) {
      case Element.fire:
        seq.addAll(['Boi', 'Macaco', 'Tigre']);
        break;
      case Element.water:
        seq.addAll(['Cão', 'Javali', 'Rato']);
        break;
      case Element.earth:
        seq.addAll(['Tigre', 'Cobra', 'Rato']);
        break;
      case Element.wind:
        seq.addAll(['Coelho', 'Cão', 'Pássaro']);
        break;
      case Element.lightning:
        seq.addAll(['Boi', 'Coelho', 'Macaco']);
        break;
      default:
        seq.addAll(['Cobra']);
    }
    if (a.basePower > 80) seq.add('Selo da Liberação');
    return seq;
  }

  void _refreshVisual() {
    visualId = 'chakra_${element.name}_${mode.name}';
  }
}
