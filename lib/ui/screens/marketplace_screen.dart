import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import '../../data/catalogs/clothing_catalog.dart';
import '../../economy/item_catalog.dart';
import '../../economy/marketplace.dart';
import '../../models/character.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key, required this.character});

  final Character character;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int _tab = 0; // 0 = comprar, 1 = vender (postar)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolsa de Velmoria'),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabBtn(0, 'OFERTAS'),
              const SizedBox(width: 24),
              _tabBtn(1, 'POSTAR'),
            ],
          ),
        ),
      ),
      body: _tab == 0 ? _listingsTab() : _postTab(),
    );
  }

  Widget _tabBtn(int idx, String label) {
    final active = _tab == idx;
    return GestureDetector(
      onTap: () => setState(() => _tab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AkyronTheme.goldEon : Colors.transparent, width: 2,
            ),
          ),
        ),
        child: Text(label,
            style: TextStyle(
              color: active ? AkyronTheme.goldEon : AkyronTheme.paperBeige,
              fontWeight: FontWeight.w800, letterSpacing: 2,
            )),
      ),
    );
  }

  Widget _listingsTab() {
    final listings = Marketplace.instance.listings;
    if (listings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Nenhuma oferta ativa.\nA bolsa precisa que jogadores postem.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AkyronTheme.paperBeige),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: listings.length,
      itemBuilder: (ctx, i) {
        final l = listings[i];
        final itemName = _itemName(l.itemId);
        return ListTile(
          leading: const Icon(Icons.storefront, color: AkyronTheme.cyanSpirit),
          title: Text('$itemName  x${l.quantity}'),
          subtitle: Text('por ${l.sellerName} ${l.sellerId.formatted}'),
          trailing: FilledButton(
            onPressed: widget.character.coins >= l.pricePerUnit
                ? () => _buy(l, 1)
                : null,
            child: Text('${Currency.format(l.pricePerUnit)}/un'),
          ),
        );
      },
    );
  }

  Widget _postTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Postar item do seu inventário (5% de taxa da bolsa).',
            style: TextStyle(color: AkyronTheme.paperBeige),
          ),
        ),
        for (final entry in widget.character.inventory.all.entries)
          _PostRow(
            itemId: entry.key,
            stack: entry.value,
            suggested: _suggestedPrice(entry.key),
            onPost: (qty, price) async {
              final post = Marketplace.instance.post(
                sellerId: widget.character.playerId,
                sellerName: widget.character.displayName,
                itemId: entry.key,
                quantity: qty,
                pricePerUnit: price,
              );
              widget.character.inventory.remove(entry.key, qty);
              AudioDirector.instance.sfx(Sfx.coinPickup);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Postado: ${_itemName(post.itemId)} x$qty por ${Currency.format(price)}/un',
                  ),
                ),
              );
              setState(() {});
            },
          ),
      ],
    );
  }

  Future<void> _buy(MarketListing l, int qty) async {
    final res = Marketplace.instance.buy(
      listingId: l.id,
      quantity: qty,
      buyerCoins: widget.character.coins,
    );
    if (!res.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'Falhou.')),
      );
      return;
    }
    setState(() {
      widget.character.coins -= res.totalCost!;
      widget.character.inventory.add(res.itemId!, res.quantity!);
    });
    AudioDirector.instance.sfx(Sfx.coinPickup);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Comprou ${_itemName(res.itemId!)} x${res.quantity}. '
          'Taxa: ${Currency.format(res.brokerFee!)}',
        ),
      ),
    );
  }

  int _suggestedPrice(String id) {
    final item = ItemCatalog.byId(id);
    if (item != null) return (item.basePrice * 1.2).round();
    final cloth = ClothingCatalog.byId(id);
    if (cloth != null) {
      const Map<String, int> p = {
        'Comum': 60, 'Raro': 300, 'Épico': 1500,
        'Lendário': 8000, 'Transcendente': 40000,
      };
      return p[cloth.rarity.label] ?? 80;
    }
    return 50;
  }

  String _itemName(String id) {
    final item = ItemCatalog.byId(id);
    if (item != null) return item.name;
    final cloth = ClothingCatalog.byId(id);
    if (cloth != null) return cloth.name;
    return id;
  }
}

class _PostRow extends StatefulWidget {
  const _PostRow({
    required this.itemId,
    required this.stack,
    required this.suggested,
    required this.onPost,
  });

  final String itemId;
  final int stack;
  final int suggested;
  final Future<void> Function(int qty, int price) onPost;

  @override
  State<_PostRow> createState() => _PostRowState();
}

class _PostRowState extends State<_PostRow> {
  late final TextEditingController _qty =
      TextEditingController(text: '1');
  late final TextEditingController _price =
      TextEditingController(text: widget.suggested.toString());

  @override
  void dispose() {
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.itemId, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                  Text('estoque: ${widget.stack}'),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _qty,
                decoration: const InputDecoration(labelText: 'Qtd'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: TextField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'LE/un'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                final qty = int.tryParse(_qty.text) ?? 0;
                final price = int.tryParse(_price.text) ?? 0;
                if (qty <= 0 || price <= 0 || qty > widget.stack) return;
                widget.onPost(qty, price);
              },
              child: const Text('Postar'),
            ),
          ],
        ),
      ),
    );
  }
}
