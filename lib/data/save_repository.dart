import 'dart:convert';

import '../core/id_generator.dart';
import '../models/appearance.dart';
import '../models/character.dart';
import '../models/equipment.dart';
import '../models/inventory.dart';
import '../models/stats.dart';
import 'kv_store.dart';

/// Persistência de personagens. Usa SharedPreferences via KvStore para
/// funcionar em web, mobile e desktop sem depender do sqflite (que não
/// existe na web).
class SaveRepository {
  static const String _kKey = 'akyron.characters.v1';

  Future<List<Character>> list() async {
    final rows = await KvStore.instance.readList(_kKey);
    return rows.map(_decode).whereType<Character>().toList();
  }

  Future<Character?> load(String id) async {
    final rows = await KvStore.instance.readList(_kKey);
    for (final r in rows) {
      if (r['id'] == id) return _decode(r);
    }
    return null;
  }

  Future<void> save(Character c) async {
    final rows = await KvStore.instance.readList(_kKey);
    final i = rows.indexWhere((r) => r['id'] == c.id);
    final blob = {
      'id': c.id,
      'player_id': c.playerId.formatted,
      'name': c.displayName,
      'json': jsonEncode(c.toJson()),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
    if (i == -1) {
      rows.add(blob);
    } else {
      rows[i] = blob;
    }
    await KvStore.instance.writeList(_kKey, rows);
  }

  Future<void> delete(String id) async {
    final rows = await KvStore.instance.readList(_kKey);
    rows.removeWhere((r) => r['id'] == id);
    await KvStore.instance.writeList(_kKey, rows);
  }

  Character? _decode(Map<String, dynamic> row) {
    try {
      final j = jsonDecode(row['json'] as String) as Map<String, dynamic>;
      return Character(
        uuid: j['id'] as String,
        playerId: PlayerId.parse(j['pid'] as String),
        displayName: j['name'] as String,
        appearance:
            Appearance.fromJson(j['appearance'] as Map<String, dynamic>),
        power: Character.powerFromJson(j['power'] as Map<String, dynamic>),
        baseStats: Stats.fromJson(j['baseStats'] as Map<String, dynamic>),
        loadout: Loadout(),
        inventory: Inventory.fromJson(j['inventory'] as Map<String, dynamic>),
        level: j['level'] ?? 1,
        xp: j['xp'] ?? 0,
        coins: j['coins'] ?? 0,
        title: j['title'] ?? '',
        region: j['region'] ?? 'region.starthorn',
      );
    } catch (_) {
      return null;
    }
  }
}
