import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import '../../data/catalogs/clothing_catalog.dart';
import '../../economy/economy_models.dart';
import '../../economy/item_catalog.dart';
import '../../economy/shop_catalog.dart';
import '../../models/character.dart';
import '../../models/enums.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.character, required this.shop});

  final Character character;
  final NpcShop shop;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _tab = 0; // 0 = comprar, 1 = vender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabBtn(0, 'COMPRAR'),
              const SizedBox(width: 24),
              _tabBtn(1, 'VENDER'),
            ],
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                Currency.format(widget.character.coins),
                style: const TextStyle(
                  color: AkyronTheme.goldEon,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AkyronTheme.deepNight,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.person, color: AkyronTheme.cyanSpirit, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.shop.npc,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.shop.greeting,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AkyronTheme.paperBeige,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _tab == 0 ? _buyTab() : _sellTab()),
        ],
      ),
    );
  }

  Widget _tabBtn(int idx, String label) {
    final active = _tab == idx;
    return GestureDetector(
      onTap: () {
        AudioDirector.instance.sfx(Sfx.uiClick);
        setState(() => _tab = idx);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AkyronTheme.goldEon : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AkyronTheme.goldEon : AkyronTheme.paperBeige,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buyTab() {
    final items = widget.shop.stock
        .map((id) => _resolveItem(id))
        .where((e) => e != null)
        .cast<_ShopRow>()
        .toList();
    if (items.isEmpty) {
      return const Center(child: Text('Estoque vazio.'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final row = items[i];
        final canAfford = widget.character.coins >= row.price;
        return ListTile(
          leading: Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: AkyronTheme.deepNight),
            child: Icon(row.icon, color: row.color),
          ),
          title: Text(row.name),
          subtitle: Text(
            '${row.rarity} • ${row.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: FilledButton(
            onPressed: canAfford ? () => _buy(row) : null,
            child: Text(Currency.format(row.price)),
          ),
        );
      },
    );
  }

  Widget _sellTab() {
    final inv = widget.character.inventory.all;
    final lines = <_ShopRow>[];
    for (final entry in inv.entries) {
      final row = _resolveItem(entry.key);
      if (row != null) {
        lines.add(row.copyWith(quantity: entry.value));
      }
    }
    if (lines.isEmpty) {
      return const Center(child: Text('Inventário vazio.'));
    }
    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (ctx, i) {
        final row = lines[i];
        final sellPrice = (row.price * widget.shop.buybackRate).round();
        return ListTile(
          leading: Icon(row.icon, color: row.color),
          title: Text('${row.name}  x${row.quantity}'),
          subtitle: Text('NPC paga ${Currency.format(sellPrice)} cada'),
          trailing: FilledButton(
            onPressed: row.quantity > 0 ? () => _sell(row, sellPrice) : null,
            child: const Text('Vender 1'),
          ),
        );
      },
    );
  }

  _ShopRow? _resolveItem(String id) {
    final item = ItemCatalog.byId(id);
    if (item != null) {
      return _ShopRow(
        id: id,
        name: item.name,
        description: item.description,
        rarity: item.rarity.label,
        price: item.basePrice,
        icon: _iconFor(item),
        color: _colorFor(item),
      );
    }
    final cloth = ClothingCatalog.byId(id);
    if (cloth != null) {
      // Roupas têm um preço derivado da raridade (placeholder).
      const Map<String, int> _rarityPrices = {
        'Comum': 50, 'Raro': 250, 'Épico': 1200,
        'Lendário': 6000, 'Transcendente': 30000,
      };
      final price = _rarityPrices[cloth.rarity.label] ?? 50;
      return _ShopRow(
        id: id,
        name: cloth.name,
        description: cloth.flavor,
        rarity: cloth.rarity.label,
        price: price,
        icon: Icons.checkroom,
        color: cloth.tintMain,
      );
    }
    return null;
  }

  IconData _iconFor(dynamic i) {
    if (i is ConsumableItem) {
      switch (i.subcategory) {
        case 'potion':
          return Icons.science;
        case 'tea':
          return Icons.local_cafe;
        case 'pill':
          return Icons.medical_services;
        default:
          return Icons.fastfood;
      }
    }
    if (i is MaterialItem) return Icons.grass;
    if (i is SpellbookItem) return Icons.menu_book;
    if (i is GrimoireListing) return Icons.auto_stories;
    return Icons.inventory_2;
  }

  Color _colorFor(dynamic i) {
    if (i is GrimoireListing) return AkyronTheme.violetArcane;
    if (i is SpellbookItem) return AkyronTheme.cyanSpirit;
    if (i is MaterialItem) return Colors.greenAccent;
    return AkyronTheme.goldEon;
  }

  Future<void> _buy(_ShopRow row) async {
    AudioDirector.instance.sfx(Sfx.coinPickup);
    setState(() {
      widget.character.coins -= row.price;
      widget.character.inventory.add(row.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comprou: ${row.name}')),
    );
  }

  Future<void> _sell(_ShopRow row, int price) async {
    AudioDirector.instance.sfx(Sfx.coinPickup);
    setState(() {
      widget.character.inventory.remove(row.id);
      widget.character.coins += price;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vendeu ${row.name} por ${Currency.format(price)}')),
    );
  }
}

class _ShopRow {
  _ShopRow({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    required this.price,
    required this.icon,
    required this.color,
    this.quantity = 1,
  });

  final String id;
  final String name;
  final String description;
  final String rarity;
  final int price;
  final IconData icon;
  final Color color;
  int quantity;

  _ShopRow copyWith({int? quantity}) => _ShopRow(
        id: id, name: name, description: description, rarity: rarity,
        price: price, icon: icon, color: color, quantity: quantity ?? this.quantity,
      );
}
