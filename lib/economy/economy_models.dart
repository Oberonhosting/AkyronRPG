import '../models/enums.dart';
import '../models/stats.dart';

/// Base de todos os itens vendáveis/colecionáveis (não-vestíveis).
/// Roupas vivem em `clothing_catalog.dart` e seguem outra raiz, mas
/// também têm um `basePrice` para a economia.
abstract class GameItem {
  const GameItem({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    required this.basePrice,
    required this.iconAsset,
    this.flavor = '',
  });

  final String id;
  final String name;
  final String description;
  final Rarity rarity;

  /// Preço em **Lascas de Éon** (LE) na primeira venda do NPC. Marketplace
  /// player-to-player começa flutuando ao redor deste valor.
  final int basePrice;

  final String iconAsset;
  final String flavor;

  /// Categoria para filtros de loja.
  String get category;
}

/// Efeitos que uma comida/poção pode causar ao ser consumida.
enum ConsumableEffectKind {
  healHp,
  healMp,
  healChakra,
  healCursed,
  buffAttack,
  buffSpirit,
  buffSpeed,
  buffDefense,
  cureStatus,
  fullHeal,
  awakenInstant,
  xpBoost,
  coinBoost,
}

class ConsumableEffect {
  const ConsumableEffect({
    required this.kind,
    this.amount = 0,
    this.percent = 0,
    this.durationTurns = 0,
    this.statusCured,
  });

  final ConsumableEffectKind kind;
  final int amount;     // valor absoluto (HP, MP)
  final int percent;    // valor percentual
  final int durationTurns;
  final StatusEffect? statusCured;
}

/// Comida e poções — itens consumíveis. Aplica efeitos em [Stats].
class ConsumableItem extends GameItem {
  const ConsumableItem({
    required super.id,
    required super.name,
    required super.description,
    required super.rarity,
    required super.basePrice,
    required super.iconAsset,
    required this.effects,
    this.subcategory = 'food',
    super.flavor,
  });

  /// 'food', 'potion', 'tea', 'pill', 'rationKit'
  final String subcategory;
  final List<ConsumableEffect> effects;

  @override
  String get category => 'consumable';

  /// Aplica os efeitos diretos em [s]. Retorna mensagem para log.
  String consume(Stats s) {
    final msgs = <String>[];
    for (final e in effects) {
      switch (e.kind) {
        case ConsumableEffectKind.healHp:
          final amt = e.amount + (s.maxHp * e.percent ~/ 100);
          s.hp = (s.hp + amt).clamp(0, s.maxHp);
          msgs.add('+$amt HP');
          break;
        case ConsumableEffectKind.healMp:
          final amt = e.amount + (s.maxMp * e.percent ~/ 100);
          s.mp = (s.mp + amt).clamp(0, s.maxMp);
          msgs.add('+$amt MP');
          break;
        case ConsumableEffectKind.healChakra:
          final amt = e.amount + (s.maxChakra * e.percent ~/ 100);
          s.chakra = (s.chakra + amt).clamp(0, s.maxChakra);
          msgs.add('+$amt Chakra');
          break;
        case ConsumableEffectKind.healCursed:
          final amt = e.amount + (s.maxCursedEnergy * e.percent ~/ 100);
          s.cursedEnergy = (s.cursedEnergy + amt).clamp(0, s.maxCursedEnergy);
          msgs.add('+$amt CE');
          break;
        case ConsumableEffectKind.fullHeal:
          s.hp = s.maxHp;
          s.mp = s.maxMp;
          s.chakra = s.maxChakra;
          s.cursedEnergy = s.maxCursedEnergy;
          msgs.add('Recuperação total');
          break;
        case ConsumableEffectKind.buffAttack:
          msgs.add('Ataque +${e.amount} por ${e.durationTurns} turnos');
          break;
        case ConsumableEffectKind.buffSpirit:
          msgs.add('Espírito +${e.amount} por ${e.durationTurns} turnos');
          break;
        case ConsumableEffectKind.buffSpeed:
          msgs.add('Velocidade +${e.amount} por ${e.durationTurns} turnos');
          break;
        case ConsumableEffectKind.buffDefense:
          msgs.add('Defesa +${e.amount} por ${e.durationTurns} turnos');
          break;
        case ConsumableEffectKind.cureStatus:
          msgs.add('Cura ${e.statusCured?.name ?? "qualquer status"}');
          break;
        case ConsumableEffectKind.awakenInstant:
          msgs.add('Despertar instantâneo!');
          break;
        case ConsumableEffectKind.xpBoost:
          msgs.add('XP +${e.percent}% por ${e.durationTurns} turnos');
          break;
        case ConsumableEffectKind.coinBoost:
          msgs.add('Lascas +${e.percent}% por ${e.durationTurns} turnos');
          break;
      }
    }
    s.clamp();
    return msgs.join(' • ');
  }
}

/// Materiais (ervas, minérios, partes de monstro, essências, tecidos).
class MaterialItem extends GameItem {
  const MaterialItem({
    required super.id,
    required super.name,
    required super.description,
    required super.rarity,
    required super.basePrice,
    required super.iconAsset,
    required this.subcategory,
    super.flavor,
  });

  /// 'herb', 'ore', 'monsterPart', 'essence', 'fabric', 'gem'
  final String subcategory;

  @override
  String get category => 'material';
}

/// Livro que ensina uma habilidade. Ao "usar", o jogador aprende a
/// magia/jutsu/forma — desde que tenha o sistema certo e level mínimo.
class SpellbookItem extends GameItem {
  const SpellbookItem({
    required super.id,
    required super.name,
    required super.description,
    required super.rarity,
    required super.basePrice,
    required super.iconAsset,
    required this.teachesAbilityId,
    required this.requiredSystem,
    this.requiredLevel = 1,
    super.flavor,
  });

  final String teachesAbilityId;
  final PowerSystem requiredSystem;
  final int requiredLevel;

  @override
  String get category => 'spellbook';
}

/// Grimório para venda. Quando comprado e "ativado", substitui ou
/// adiciona ao slot de power do jogador (sistema = grimoire).
class GrimoireListing extends GameItem {
  const GrimoireListing({
    required super.id,
    required super.name,
    required super.description,
    required super.rarity,
    required super.basePrice,
    required super.iconAsset,
    required this.leaves,
    required this.element,
    super.flavor,
  });

  final int leaves;
  final Element element;

  @override
  String get category => 'grimoire';
}
