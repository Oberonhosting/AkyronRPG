import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import '../../economy/shop_catalog.dart';
import '../../models/character.dart';
import 'housing_screen.dart';
import 'marketplace_screen.dart';
import 'shop_screen.dart';

/// "Centro" da cidade — atalho pra todas as atividades de economia.
class CityHubScreen extends StatelessWidget {
  const CityHubScreen({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final shops = ShopCatalog.byRegion(character.region).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidade'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                Currency.format(character.coins),
                style: const TextStyle(
                  color: AkyronTheme.goldEon,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HubButton(
            icon: Icons.storefront,
            label: 'Lojas locais (${shops.length})',
            subtitle: 'Comerciantes da sua região',
            onTap: () => _showLocalShops(context, shops),
          ),
          _HubButton(
            icon: Icons.account_balance,
            label: 'Bolsa de Velmoria',
            subtitle: 'Marketplace player ↔ player',
            onTap: () {
              AudioDirector.instance.sfx(Sfx.uiClick);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MarketplaceScreen(character: character),
              ));
            },
          ),
          _HubButton(
            icon: Icons.home_work,
            label: 'Imobiliária & Hotéis',
            subtitle: 'Compre uma casa ou alugue um quarto',
            onTap: () {
              AudioDirector.instance.sfx(Sfx.uiClick);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => HousingScreen(character: character),
              ));
            },
          ),
        ],
      ),
    );
  }

  void _showLocalShops(BuildContext context, List<NpcShop> shops) {
    if (shops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma loja nesta região.')),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: [
          for (final s in shops)
            ListTile(
              leading: const Icon(Icons.storefront, color: AkyronTheme.goldEon),
              title: Text(s.name),
              subtitle: Text(s.specialty),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ShopScreen(character: character, shop: s),
                ));
              },
            ),
        ],
      ),
    );
  }
}

class _HubButton extends StatelessWidget {
  const _HubButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 36, color: AkyronTheme.goldEon),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
