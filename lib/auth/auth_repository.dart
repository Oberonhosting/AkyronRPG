import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm, Sqflite;
import 'package:uuid/uuid.dart';

import '../core/id_generator.dart';
import '../data/local_db.dart';
import 'auth_models.dart';

/// Repositório de contas. Cada conta vive em SQLite local (tabela
/// `accounts`). Quando o online (Supabase) for ligado, este repositório
/// vira a camada local de cache e o `OnlineAuthRepository` substitui.
class AuthRepository {
  AuthRepository({Random? rng}) : _rng = rng ?? Random.secure();

  final Random _rng;
  static const int _saltBytes = 16;
  static const int _minPasswordLen = 4;
  static const int _maxUsernameLen = 14;
  static const int _minUsernameLen = 3;

  // ───────────────────────── Registro ─────────────────────────
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final usernameError = _validateUsername(username);
    if (usernameError != null) return AuthResult.fail(usernameError);
    if (password.length < _minPasswordLen) {
      return AuthResult.fail('A senha precisa ter ao menos $_minPasswordLen caracteres.');
    }

    final db = await LocalDb.instance();

    // 1) Username livre?
    final dupe = await db.query(
      'accounts',
      where: 'username_lc = ?',
      whereArgs: [username.toLowerCase()],
      limit: 1,
    );
    if (dupe.isNotEmpty) {
      return AuthResult.fail('Este nome de usuário já está em uso.');
    }

    // 2) Gera #ID público único (retry até encontrar livre).
    final playerId = await _allocateUniquePlayerId(username, db);

    final salt = _randomSaltHex();
    final hash = _hashPassword(password, salt);
    final now = DateTime.now();

    final account = Account(
      id: const Uuid().v4(),
      username: username.trim(),
      email: email.trim(),
      playerId: playerId,
      passwordHash: hash,
      salt: salt,
      createdAt: now,
      lastLoginAt: now,
    );

    await db.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return AuthResult.ok(account);
  }

  // ───────────────────────── Login ─────────────────────────
  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final db = await LocalDb.instance();
    final lc = usernameOrEmail.trim().toLowerCase();

    final rows = await db.query(
      'accounts',
      where: 'username_lc = ? OR email = ?',
      whereArgs: [lc, usernameOrEmail.trim()],
      limit: 1,
    );
    if (rows.isEmpty) {
      return AuthResult.fail('Conta não encontrada.');
    }
    final acc = Account.fromMap(rows.first);
    final computed = _hashPassword(password, acc.salt);
    if (computed != acc.passwordHash) {
      return AuthResult.fail('Senha incorreta.');
    }
    acc.lastLoginAt = DateTime.now();
    await db.update(
      'accounts',
      {'last_login_at': acc.lastLoginAt.millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [acc.id],
    );
    return AuthResult.ok(acc);
  }

  // ───────────────────────── Helpers ─────────────────────────
  Future<Account?> getById(String accountId) async {
    final db = await LocalDb.instance();
    final rows = await db.query('accounts',
        where: 'id = ?', whereArgs: [accountId], limit: 1);
    return rows.isEmpty ? null : Account.fromMap(rows.first);
  }

  Future<int> totalAccounts() async {
    final db = await LocalDb.instance();
    final c = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM accounts'),
    );
    return c ?? 0;
  }

  String? _validateUsername(String username) {
    final u = username.trim();
    if (u.length < _minUsernameLen || u.length > _maxUsernameLen) {
      return 'Nome de usuário precisa ter de $_minUsernameLen a $_maxUsernameLen caracteres.';
    }
    if (!RegExp(r'^[A-Za-z][A-Za-z0-9_]*$').hasMatch(u)) {
      return 'Use letras, números e _ apenas. Comece com letra.';
    }
    return null;
  }

  Future<PlayerId> _allocateUniquePlayerId(String username, db) async {
    for (var i = 0; i < 50; i++) {
      final candidate = PlayerId.fromName(username, rng: _rng);
      final dupe = await db.query(
        'accounts',
        where: 'player_id = ?',
        whereArgs: [candidate.formatted],
        limit: 1,
      );
      if (dupe.isEmpty) return candidate;
    }
    // Fallback extremamente improvável.
    throw StateError('Não foi possível alocar um #ID único após 50 tentativas.');
  }

  String _randomSaltHex() {
    final bytes = List<int>.generate(_saltBytes, (_) => _rng.nextInt(256));
    return _toHex(bytes);
  }

  String _hashPassword(String password, String saltHex) {
    final salt = _fromHex(saltHex);
    final input = <int>[...salt, ...utf8.encode(password)];
    return sha256.convert(input).toString();
  }

  String _toHex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  List<int> _fromHex(String hex) => [
        for (var i = 0; i < hex.length; i += 2)
          int.parse(hex.substring(i, i + 2), radix: 16),
      ];
}

