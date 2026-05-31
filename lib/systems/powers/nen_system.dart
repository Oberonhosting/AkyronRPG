import '../../models/enums.dart';
import 'power_base.dart';

/// Nen — sistema inspirado em HxH.
/// O tipo é descoberto no "Despertar do Aura" e nunca muda.
class NenCore extends PowerCore {
  NenCore({required this.type, required Element element})
      : super(
          system: PowerSystem.nen,
          element: element,
          rarity: Rarity.rare,
        ) {
    formName = 'Aura ${type.label}';
    visualId = 'nen_${type.name}';
  }

  final NenType type;

  /// Juramentos auto-impostos — quanto mais restritivo, mais poderosa a
  /// habilidade pessoal. Cada juramento adiciona multiplicador.
  final List<NenVow> vows = [];

  double get vowMultiplier =>
      vows.fold<double>(1.0, (acc, v) => acc * v.multiplier);

  @override
  bool tryEvolve() {
    // Em vez de "subir forma", o usuário de Nen vai aprimorando proficiência
    // por afinidade. Cada 200 XP da habilidade própria abre 1 slot.
    return false;
  }

  /// Adiciona um juramento — não pode ser removido (regra de Nen).
  void addVow(NenVow vow) => vows.add(vow);
}

/// Juramento que o usuário faz para tornar sua habilidade mais forte.
class NenVow {
  const NenVow({
    required this.description,
    required this.multiplier,
    required this.penaltyIfBroken,
  });

  final String description;
  final double multiplier;
  final String penaltyIfBroken;
}
