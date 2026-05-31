import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import '../../economy/housing_catalog.dart';
import '../../models/character.dart';

class HousingScreen extends StatefulWidget {
  const HousingScreen({super.key, required this.character});

  final Character character;

  @override
  State<HousingScreen> createState() => _HousingScreenState();
}

class _HousingScreenState extends State<HousingScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imobiliária & Pousadas'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(Currency.format(widget.character.coins),
                  style: const TextStyle(
                    color: AkyronTheme.goldEon,
                    fontWeight: FontWeight.w800,
                  )),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabBtn(0, 'CASAS'),
              const SizedBox(width: 24),
              _tabBtn(1, 'HOTÉIS'),
            ],
          ),
        ),
      ),
      body: _tab == 0 ? _housesTab() : _hotelsTab(),
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

  Widget _housesTab() {
    return ListView.builder(
      itemCount: HousingCatalog.houses.length,
      itemBuilder: (ctx, i) {
        final h = HousingCatalog.houses[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.home, color: AkyronTheme.goldEon, size: 32),
            title: Text(h.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_tierLabel(h.tier)} • ${h.region.split('.').last}'),
                Text(h.description, style: const TextStyle(fontSize: 12, color: AkyronTheme.paperBeige)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: [
                    for (final f in h.features)
                      Chip(label: Text(f, style: const TextStyle(fontSize: 9))),
                  ],
                ),
                Text('Baú: ${h.storageSlots} slots', style: const TextStyle(fontSize: 11)),
              ],
            ),
            isThreeLine: true,
            trailing: FilledButton(
              onPressed: widget.character.coins >= h.price ? () => _buyHouse(h) : null,
              child: Text(Currency.format(h.price), textAlign: TextAlign.center),
            ),
          ),
        );
      },
    );
  }

  Widget _hotelsTab() {
    return ListView.builder(
      itemCount: HousingCatalog.hotelRooms.length,
      itemBuilder: (ctx, i) {
        final r = HousingCatalog.hotelRooms[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.bed, color: AkyronTheme.cyanSpirit, size: 32),
            title: Text('${r.hotelName} — ${_tierLabel(r.tier)}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.description, style: const TextStyle(fontSize: 12)),
                Text('Cura ${r.healPercent}% • ${r.region.split('.').last}',
                    style: const TextStyle(fontSize: 11)),
                if (r.buffs.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final b in r.buffs)
                        Chip(label: Text(b, style: const TextStyle(fontSize: 9))),
                    ],
                  ),
              ],
            ),
            trailing: FilledButton(
              onPressed: widget.character.coins >= r.pricePerNight ? () => _bookRoom(r) : null,
              child: Text(Currency.format(r.pricePerNight)),
            ),
          ),
        );
      },
    );
  }

  String _tierLabel(String t) => switch (t) {
        'common' => 'Comum',
        'comfortable' => 'Confortável',
        'manor' => 'Casarão',
        'estate' => 'Propriedade Lendária',
        'spartan' => 'Espartano',
        'royal' => 'Suíte Real',
        _ => t,
      };

  Future<void> _buyHouse(House h) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Comprar ${h.name}?'),
        content: Text(
          'Custa ${Currency.formatLong(h.price)}. '
          'A escritura fica registrada no seu nome no Cartório de Velmoria.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Comprar')),
        ],
      ),
    );
    if (ok != true) return;
    AudioDirector.instance.sfx(Sfx.unlockSkill);
    setState(() {
      widget.character.coins -= h.price;
      widget.character.region = h.region;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bem-vindo a ${h.name}.')),
    );
  }

  Future<void> _bookRoom(HotelRoom r) async {
    AudioDirector.instance.sfx(Sfx.coinPickup);
    final s = widget.character.baseStats;
    setState(() {
      widget.character.coins -= r.pricePerNight;
      s.hp = (s.hp + (s.maxHp * r.healPercent ~/ 100)).clamp(0, s.maxHp);
      s.mp = (s.mp + (s.maxMp * r.healPercent ~/ 100)).clamp(0, s.maxMp);
      if (s.maxChakra > 0) {
        s.chakra = (s.chakra + (s.maxChakra * r.healPercent ~/ 100)).clamp(0, s.maxChakra);
      }
      if (s.maxCursedEnergy > 0) {
        s.cursedEnergy = (s.cursedEnergy + (s.maxCursedEnergy * r.healPercent ~/ 100))
            .clamp(0, s.maxCursedEnergy);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você dormiu em ${r.hotelName}. ${r.buffs.isNotEmpty ? "Buff: ${r.buffs.join(", ")}" : ""}')),
    );
  }
}
