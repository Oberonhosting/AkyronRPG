import '../../models/enums.dart';
import '../../models/stats.dart';

/// Uma habilidade ativa: magia, jutsu, forma de respiração, técnica.
class Ability {
  const Ability({
    required this.id,
    required this.name,
    required this.system,
    required this.element,
    required this.rarity,
    required this.basePower,
    required this.mpCost,
    this.chakraCost = 0,
    this.cursedCost = 0,
    this.cooldownTurns = 0,
    this.hits = 1,
    this.statuses = const [],
    this.targetsAll = false,
    this.isUltimate = false,
    this.battleCry = '',
    this.flavor = '',
  });

  final String id;
  final String name;
  final PowerSystem system;
  final Element element;
  final Rarity rarity;
  final int basePower;
  final int mpCost;
  final int chakraCost;
  final int cursedCost;
  final int cooldownTurns;
  final int hits;
  final List<StatusEffect> statuses;
  final bool targetsAll;
  final bool isUltimate;

  /// Texto que aparece em letras grandes estilo mangá ao ser ativada.
  final String battleCry;
  final String flavor;

  /// Quanto dano essa habilidade causa em [target] vindo de [user].
  int computeDamage(Stats user, Stats target) {
    final atk = system == PowerSystem.zanpakuto || system == PowerSystem.breathing
        ? user.attack
        : user.spirit;
    final def = system == PowerSystem.zanpakuto || system == PowerSystem.breathing
        ? target.defense
        : target.resist;
    final raw = ((basePower + atk * 1.4) - def * 0.9).clamp(1, 9999);
    return (raw * hits).round();
  }
}

/// Núcleo do sistema de poder de um personagem. Cada sistema concreto
/// (Grimório, Zanpakutō, Chakra, etc.) estende esta classe.
abstract class PowerCore {
  PowerCore({
    required this.system,
    required this.element,
    required this.rarity,
  });

  final PowerSystem system;
  final Element element;
  final Rarity rarity;

  /// Habilidades atualmente desbloqueadas.
  List<Ability> abilities = [];

  /// Nome curto da forma atual (ex.: "Forma Base", "Shikai", "Bankai",
  /// "Modo Sábio"). Usado no HUD.
  String formName = 'Forma Base';

  /// Identificador visual atual (ex.: "grimoire_l3_red"). PlayerComponent
  /// usa para escolher sprite e cor de aura.
  String visualId = 'base';

  /// Tenta evoluir para a próxima forma. Retorna true se subiu.
  bool tryEvolve();

  /// Hook chamado a cada ação do combate (regen, manutenção de modo, etc.).
  void onTurnStart(Stats owner) {}

  /// Quanto custa em recurso primário usar [a]. Sistemas podem sobrescrever.
  bool canPay(Ability a, Stats s) =>
      s.mp >= a.mpCost &&
      s.chakra >= a.chakraCost &&
      s.cursedEnergy >= a.cursedCost;

  void pay(Ability a, Stats s) {
    s.mp -= a.mpCost;
    s.chakra -= a.chakraCost;
    s.cursedEnergy -= a.cursedCost;
    s.clamp();
  }

  Map<String, dynamic> toJson() => {
        'system': system.name,
        'element': element.name,
        'rarity': rarity.name,
        'form': formName,
        'visual': visualId,
        'abilities': abilities.map((a) => a.id).toList(),
      };
}
