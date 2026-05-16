import 'package:flutter_test/flutter_test.dart';

import 'package:akyron_rpg/core/id_generator.dart';
import 'package:akyron_rpg/data/catalogs/ability_catalog.dart';
import 'package:akyron_rpg/data/catalogs/clothing_catalog.dart';
import 'package:akyron_rpg/lore/world_lore.dart';
import 'package:akyron_rpg/models/enums.dart';
import 'package:akyron_rpg/systems/powers/grimoire_system.dart';

void main() {
  group('PlayerId', () {
    test('parse e formatação são bijetivos', () {
      final id = PlayerId.parse('#Yami4521');
      expect(id.handle, 'Yami');
      expect(id.tag, '4521');
      expect(id.formatted, '#Yami4521');
    });

    test('fromName higieniza caracteres', () {
      final id = PlayerId.fromName('!! Y@mí ## ');
      expect(id.handle.toLowerCase().contains('y'), true);
      expect(id.tag.length, 4);
    });
  });

  group('Catálogos', () {
    test('todas as habilidades por sistema têm pelo menos uma ultimate', () {
      for (final s in PowerSystem.values) {
        final hasUlt = AbilityCatalog.bySystem(s).any((a) => a.isUltimate);
        expect(hasUlt, isTrue, reason: 'Sem ultimate para $s');
      }
    });

    test('roupas têm slot e raridade definidos', () {
      for (final c in ClothingCatalog.all()) {
        expect(c.id.isNotEmpty, true);
        expect(c.name.isNotEmpty, true);
        expect(c.spriteAsset.isNotEmpty, true);
      }
    });
  });

  group('Lore', () {
    test('seis correntes presentes', () {
      expect(WorldLore.currents.length, 6);
    });
  });

  group('Grimório', () {
    test('aprender respeita capacidade e elemento', () {
      final g = GrimoireCore(element: Element.fire, leaves: 1);
      final a = AbilityCatalog.byId('grim.fire.ember_ray')!;
      expect(g.learn(a), isTrue);
      expect(g.abilities.length, 1);
    });
  });
}
