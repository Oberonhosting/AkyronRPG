import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../core/constants.dart';

/// Inicializa SQLite no mobile e no desktop. No desktop o sqflite padrão
/// não tem implementação nativa — usamos FFI.
class LocalDb {
  LocalDb._();

  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dir = await getApplicationSupportDirectory();
    final path = p.join(dir.path, AkyronK.saveDbFileName);
    _db = await openDatabase(
      path,
      version: AkyronK.saveSchemaVersion,
      onCreate: _onCreate,
    );
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE characters (
        id TEXT PRIMARY KEY,
        player_id TEXT,
        name TEXT,
        json TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE friends (
        player_id TEXT PRIMARY KEY,
        nickname TEXT,
        last_seen INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE servers_cache (
        id TEXT PRIMARY KEY,
        kind TEXT,
        name TEXT,
        host TEXT,
        port INTEGER,
        password_hash TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE progress (
        character_id TEXT PRIMARY KEY,
        region TEXT,
        completed_quests TEXT,
        battle_pass_json TEXT
      )
    ''');
  }
}
