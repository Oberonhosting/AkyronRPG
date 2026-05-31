import '../../models/enums.dart';
import 'power_base.dart';

/// Grimório — sistema inspirado em Black Clover.
/// Folhas de 1 a 5. Quanto mais folhas, mais espaço para magia.
class GrimoireCore extends PowerCore {
  GrimoireCore({
    required Element element,
    required this.leaves,
    String? title,
  })  : title = title ?? _autoTitle(element, leaves),
        super(
          system: PowerSystem.grimoire,
          element: element,
          rarity: _rarityFromLeaves(leaves),
        ) {
    visualId = 'grimoire_l${leaves}_${element.name}';
    formName = 'Grimório de ${leaves}F';
  }

  /// Número de folhas (1 a 5). 5 é extremamente raro.
  int leaves;

  /// Nome próprio do grimório, gerado ou definido pelo jogador.
  String title;

  /// Slots livres aumentam conforme as folhas.
  int get capacity => 3 + leaves * 2; // 5 / 7 / 9 / 11 / 13

  @override
  bool tryEvolve() {
    // Grimórios não "evoluem" sozinhos — folhas extras só aparecem em
    // eventos de história (Awakening of the Grimoire).
    return false;
  }

  /// Adquire uma magia se ainda houver capacidade. Retorna true se aprendeu.
  bool learn(Ability a) {
    if (abilities.length >= capacity) return false;
    if (a.element != element) return false;
    if (a.system != PowerSystem.grimoire) return false;
    abilities.add(a);
    return true;
  }

  static String _autoTitle(Element e, int leaves) {
    final base = switch (e) {
      Element.fire => 'Chama de Brasa',
      Element.dark => 'Véu da Noite-Sem-Fim',
      Element.wind => 'Pena do Vento Errante',
      Element.time => 'Ampulheta de Iyari',
      Element.space => 'Mapa Sem Bordas',
      Element.ice => 'Aurora Quebrada',
      Element.lightning => 'Sela do Trovão',
      Element.light => 'Sol Caído',
      Element.chaos => 'Tomo de Sukhenna',
      Element.life => 'Florescer Verdadeiro',
      _ => 'Códex Sem Nome',
    };
    return '$base (${leaves}F)';
  }

  static Rarity _rarityFromLeaves(int leaves) => switch (leaves) {
        5 => Rarity.transcendent,
        4 => Rarity.legendary,
        3 => Rarity.epic,
        2 => Rarity.rare,
        _ => Rarity.common,
      };
}
