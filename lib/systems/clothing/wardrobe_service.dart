import '../../data/catalogs/clothing_catalog.dart';
import '../../models/character.dart';
import '../../models/enums.dart';
import '../../models/equipment.dart';

/// Serviço de equipagem — única porta de entrada para vestir e tirar roupas
/// do personagem. Garante que o item está no inventário, que o gênero é
/// permitido e atualiza o snapshot visual.
class WardrobeService {
  WardrobeService._();

  /// Equipa um item. Retorna true se conseguiu.
  static bool equip(Character c, String itemId) {
    final item = ClothingCatalog.byId(itemId);
    if (item == null) return false;
    if (c.inventory.count(itemId) <= 0) return false;
    if (!item.allowedGenders.contains(c.appearance.gender)) return false;
    c.loadout.equip(item);
    return true;
  }

  /// Tira a peça do slot, devolve true se algo foi removido.
  static bool unequip(Character c, EquipSlot slot) {
    if (c.loadout.get(slot) == null) return false;
    c.loadout.unequip(slot);
    return true;
  }

  /// Lista o que está disponível para equipar em determinado slot,
  /// respeitando gênero.
  static List<ClothingItem> availableFor(Character c, EquipSlot slot) {
    return c.inventory
        .equippables({for (final i in ClothingCatalog.all()) i.id: i})
        .where((i) =>
            i.slot == slot && i.allowedGenders.contains(c.appearance.gender))
        .toList();
  }

  /// Conjunto descritivo da silhueta atual — usado pelo PlayerComponent
  /// para escolher sprites e por servidores online para retransmitir o
  /// visual aos outros jogadores.
  static Map<String, String?> visualSnapshot(Character c) {
    String? idOf(EquipSlot s) => c.loadout.get(s)?.id;
    return {
      'head': idOf(EquipSlot.head),
      'top': idOf(EquipSlot.top),
      'bottom': idOf(EquipSlot.bottom),
      'footwear': idOf(EquipSlot.footwear),
      'cloak': idOf(EquipSlot.cloak),
      'accessory': idOf(EquipSlot.accessory),
      'aura': idOf(EquipSlot.aura),
      'weapon': idOf(EquipSlot.weapon),
      'powerVisual': c.power.visualId,
      'hairStyle': c.appearance.hairStyle,
      // ignore: deprecated_member_use
      'hairColor': c.appearance.hairColor.value.toString(),
      'gender': c.appearance.gender.name,
      'build': c.appearance.build,
    };
  }
}
