import 'dart:convert';

import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

import '../core/id_generator.dart';
import '../models/appearance.dart';
import '../models/character.dart';
import '../models/equipment.dart';
import '../models/inventory.dart';
import '../models/stats.dart';
import 'local_db.dart';

/// Persistência de personagens no SQLite local.
class SaveRepository {
  /// Lista todos os personagens salvos no dispositivo (slots de save).
  Future<List<Character>> list() async {
    final db = await LocalDb.instance();
    final rows = await db.query('characters', orderBy: 'updated_at DESC');
    return rows.map(_decode).toList();
  }

  Future<Character?> load(String id) async {
    final db = await LocalDb.instance();
    final rows = await db.query('characters',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _decode(rows.first);
  }

  Future<void> save(Character c) async {
    final db = await LocalDb.instance();
    await db.insert(
      'characters',
      {
        'id': c.id,
        'player_id': c.playerId.formatted,
        'name': c.displayName,
        'json': jsonEncode(c.toJson()),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await LocalDb.instance();
    await db.delete('characters', where: 'id = ?', whereArgs: [id]);
  }

  Character _decode(Map<String, Object?> row) {
    final j = jsonDecode(row['json'] as String) as Map<String, dynamic>;
    return Character(
      uuid: j['id'] as String,
      playerId: PlayerId.parse(j['pid'] as String),
      displayName: j['name'] as String,
      appearance: Appearance.fromJson(j['appearance'] as Map<String, dynamic>),
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
  }
}
