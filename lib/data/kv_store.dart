import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Armazenamento chave-valor universal — funciona em web (localStorage),
/// mobile (NSUserDefaults / SharedPreferences) e desktop.
///
/// Usado por AuthRepository e SaveRepository em vez de SQLite, porque
/// sqflite não tem implementação na web e travava a tela de login.
///
/// Capacidade: ~5–10 MB no web; ilimitado em mobile/desktop.
class KvStore {
  KvStore._();
  static final KvStore instance = KvStore._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> _p() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final p = await _p();
    final raw = p.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> data) async {
    final p = await _p();
    await p.setString(key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    final p = await _p();
    final raw = p.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return (jsonDecode(raw) as Map).cast<String, dynamic>();
    } catch (_) {
      return null;
    }
  }

  Future<void> writeMap(String key, Map<String, dynamic> data) async {
    final p = await _p();
    await p.setString(key, jsonEncode(data));
  }

  Future<void> remove(String key) async {
    final p = await _p();
    await p.remove(key);
  }
}
