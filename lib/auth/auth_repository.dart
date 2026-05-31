import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../core/id_generator.dart';
import '../data/kv_store.dart';
import 'auth_models.dart';

/// Repositório de contas — armazenadas em SharedPreferences (web,
/// mobile e desktop). Cada conta é um Map serializado em um array JSON
/// sob a chave [_kKey].
class AuthRepository {
  AuthRepository({Random? rng}) : _rng = rng ?? Random.secure();

  final Random _rng;
  static const int _saltBytes = 16;
  static const int _minPasswordLen = 4;
  static const int _maxUsernameLen = 14;
  static const int _minUsernameLen = 3;
  static const String _kKey = 'akyron.accounts.v1';

  // ───────────────────────── Registro ─────────────────────────
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final usernameError = _validateUsername(username);
    if (usernameError != null) return AuthResult.fail(usernameError);
    if (password.length < _minPasswordLen) {
      return AuthResult.fail(
        'A senha precisa ter ao menos $_minPasswordLen caracteres.',
      );
    }

    final accounts = await KvStore.instance.readList(_kKey);

    // 1) Username livre?
    final lc = username.trim().toLowerCase();
    if (accounts.any((a) => a['username_lc'] == lc)) {
      return AuthResult.fail('Este nome de usuário já está em uso.');
    }

    // 2) Gera #ID público único.
    final playerId = _allocateUniquePlayerId(username, accounts);

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

    accounts.add(account.toMap());
    await KvStore.instance.writeList(_kKey, accounts);
    return AuthResult.ok(account);
  }

  // ───────────────────────── Login ─────────────────────────
  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final accounts = await KvStore.instance.readList(_kKey);
    final lc = usernameOrEmail.trim().toLowerCase();
    final email = usernameOrEmail.trim();

    Map<String, dynamic>? found;
    for (final a in accounts) {
      if (a['username_lc'] == lc || a['email'] == email) {
        found = a;
        break;
      }
    }
    if (found == null) return AuthResult.fail('Conta não encontrada.');

    final acc = Account.fromMap(found);
    final computed = _hashPassword(password, acc.salt);
    if (computed != acc.passwordHash) {
      return AuthResult.fail('Senha incorreta.');
    }

    acc.lastLoginAt = DateTime.now();
    found['last_login_at'] = acc.lastLoginAt.millisecondsSinceEpoch;
    await KvStore.instance.writeList(_kKey, accounts);
    return AuthResult.ok(acc);
  }

  // ───────────────────────── Helpers ─────────────────────────
  Future<Account?> getById(String accountId) async {
    final accounts = await KvStore.instance.readList(_kKey);
    for (final a in accounts) {
      if (a['id'] == accountId) return Account.fromMap(a);
    }
    return null;
  }

  Future<int> totalAccounts() async {
    final accounts = await KvStore.instance.readList(_kKey);
    return accounts.length;
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

  PlayerId _allocateUniquePlayerId(
    String username,
    List<Map<String, dynamic>> accounts,
  ) {
    final taken = accounts.map((a) => a['player_id'] as String).toSet();
    for (var i = 0; i < 200; i++) {
      final candidate = PlayerId.fromName(username, rng: _rng);
      if (!taken.contains(candidate.formatted)) return candidate;
    }
    throw StateError('Não foi possível alocar um #ID único.');
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
