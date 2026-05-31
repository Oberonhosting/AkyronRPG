import 'package:flutter/material.dart';

import 'enums.dart';
import 'stats.dart';

/// Uma peça de roupa/armadura/acessório do guarda-roupa do jogador.
///
/// Skins **não alteram atributos** — exceto sets lendários completos, que
/// dão bônus de lore (ver [SetBonus]).
class ClothingItem {
  ClothingItem({
    required this.id,
    required this.name,
    required this.slot,
    required this.rarity,
    required this.spriteAsset,
    required this.tintMain,
    this.tintAccent,
    this.setId,
    this.flavor = '',
    this.allowedGenders = const {Gender.masculine, Gender.feminine},
    this.bonusStats,
  });

  final String id;
  final String name;
  final EquipSlot slot;
  final Rarity rarity;
  final String spriteAsset;
  final Color tintMain;
  final Color? tintAccent;

  /// Pertence a um set? (usado para bônus lendários).
  final String? setId;

  /// Texto descritivo no inventário (lore curtinho).
  final String flavor;

  /// Restrição opcional de gênero (alguns visuais só fazem sentido em um).
  final Set<Gender> allowedGenders;

  /// Bônus de stats — só para sets lendários/transcendentes.
  final Stats? bonusStats;

  bool get isLegendaryOrAbove =>
      rarity == Rarity.legendary || rarity == Rarity.transcendent;
}

/// Bônus quando o jogador veste um set completo.
class SetBonus {
  const SetBonus({
    required this.setId,
    required this.name,
    required this.description,
    required this.requiredPieces,
    required this.bonus,
  });

  final String setId;
  final String name;
  final String description;

  /// Quantas peças do set são necessárias (ex.: 3 ou 5).
  final int requiredPieces;
  final Stats bonus;
}

/// Conjunto equipado atualmente — uma referência por slot.
class Loadout {
  Loadout({Map<EquipSlot, ClothingItem?>? items})
      : _items = items ?? {for (final s in EquipSlot.values) s: null};

  final Map<EquipSlot, ClothingItem?> _items;

  ClothingItem? get(EquipSlot s) => _items[s];

  void equip(ClothingItem item) {
    _items[item.slot] = item;
  }

  void unequip(EquipSlot s) {
    _items[s] = null;
  }

  /// Calcula bônus de stats considerando peças individuais + sets.
  Stats computeBonus(List<SetBonus> registry) {
    final total = Stats();
    final setCounts = <String, int>{};

    for (final item in _items.values) {
      if (item == null) continue;
      if (item.bonusStats != null) total.addBonuses(item.bonusStats!);
      if (item.setId != null) {
        setCounts[item.setId!] = (setCounts[item.setId!] ?? 0) + 1;
      }
    }

    for (final bonus in registry) {
      final count = setCounts[bonus.setId] ?? 0;
      if (count >= bonus.requiredPieces) total.addBonuses(bonus.bonus);
    }

    return total;
  }

  /// IDs equipados — usado para serialização.
  Map<String, String?> toJson() =>
      {for (final e in _items.entries) e.key.name: e.value?.id};
}
