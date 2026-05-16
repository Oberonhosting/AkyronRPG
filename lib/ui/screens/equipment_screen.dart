import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalogs/clothing_catalog.dart';
import '../../models/character.dart';
import '../../models/enums.dart';
import '../../models/equipment.dart';
import '../../systems/clothing/wardrobe_service.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key, required this.character});
  final Character character;

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  EquipSlot _selectedSlot = EquipSlot.top;

  @override
  Widget build(BuildContext context) {
    final available = WardrobeService.availableFor(widget.character, _selectedSlot);
    final equipped = widget.character.loadout.get(_selectedSlot);

    return Scaffold(
      appBar: AppBar(title: const Text('Guarda-roupa')),
      body: Row(
        children: [
          // Coluna de slots.
          Container(
            width: 130,
            color: AkyronTheme.deepNight,
            child: ListView(
              children: [
                for (final s in EquipSlot.values)
                  ListTile(
                    title: Text(s.label, style: const TextStyle(fontSize: 12)),
                    selected: _selectedSlot == s,
                    selectedTileColor: AkyronTheme.violetArcane.withOpacity(0.3),
                    onTap: () => setState(() => _selectedSlot = s),
                    trailing: widget.character.loadout.get(s) != null
                        ? const Icon(Icons.check_circle, size: 14, color: AkyronTheme.goldEon)
                        : null,
                  ),
              ],
            ),
          ),
          // Conteúdo.
          Expanded(
            child: Column(
              children: [
                if (equipped != null)
                  _equippedCard(equipped),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Disponíveis em ${_selectedSlot.label.toUpperCase()}',
                      style: const TextStyle(
                        color: AkyronTheme.goldEon,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                      )),
                ),
                Expanded(
                  child: available.isEmpty
                      ? const Center(child: Text('Nenhuma peça disponível neste slot.'))
                      : ListView.builder(
                          itemCount: available.length,
                          itemBuilder: (ctx, i) => _itemTile(available[i]),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _equippedCard(ClothingItem item) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: _swatch(item),
        title: Text(item.name),
        subtitle: Text('${item.rarity.label} • equipado'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            WardrobeService.unequip(widget.character, item.slot);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _itemTile(ClothingItem item) {
    final isEquipped = widget.character.loadout.get(item.slot)?.id == item.id;
    return ListTile(
      leading: _swatch(item),
      title: Text(item.name),
      subtitle: Text('${item.rarity.label} • ${item.flavor}',
          maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: FilledButton(
        onPressed: isEquipped ? null : () {
          WardrobeService.equip(widget.character, item.id);
          setState(() {});
        },
        child: Text(isEquipped ? 'Equipado' : 'Vestir'),
      ),
    );
  }

  Widget _swatch(ClothingItem item) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: item.tintMain,
        border: Border.all(color: item.tintAccent ?? Colors.black, width: 2),
      ),
    );
  }
}
