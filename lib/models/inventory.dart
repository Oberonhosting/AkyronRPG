import 'equipment.dart';

/// Inventário simples — guarda IDs de itens e quantidades.
class Inventory {
  Inventory({Map<String, int>? items}) : _items = items ?? {};

  final Map<String, int> _items;

  Map<String, int> get all => Map.unmodifiable(_items);

  int count(String id) => _items[id] ?? 0;

  void add(String id, [int amount = 1]) {
    if (amount <= 0) return;
    _items[id] = (_items[id] ?? 0) + amount;
  }

  bool remove(String id, [int amount = 1]) {
    final cur = _items[id] ?? 0;
    if (cur < amount) return false;
    final next = cur - amount;
    if (next <= 0) {
      _items.remove(id);
    } else {
      _items[id] = next;
    }
    return true;
  }

  /// Itens equipáveis (todos os ClothingItem em [catalog] presentes aqui).
  List<ClothingItem> equippables(Map<String, ClothingItem> catalog) {
    return _items.keys
        .map((id) => catalog[id])
        .whereType<ClothingItem>()
        .toList();
  }

  Map<String, dynamic> toJson() => {'items': _items};

  factory Inventory.fromJson(Map<String, dynamic> j) =>
      Inventory(items: Map<String, int>.from(j['items'] ?? const {}));
}
