import '../core/id_generator.dart';

/// Conta do jogador. Cada conta tem um único `username`, um único
/// `playerId` público (#Yami4521) e uma senha hasheada com salt.
class Account {
  Account({
    required this.id,
    required this.username,
    required this.email,
    required this.playerId,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
    required this.lastLoginAt,
  });

  /// UUID interno (referenciado pelos saves de personagem).
  final String id;

  /// Username único globalmente. Case-insensitive na comparação.
  final String username;

  /// E-mail (opcional/falsificável em offline; obrigatório no online).
  final String email;

  /// ID público #Nome0000.
  final PlayerId playerId;

  /// SHA-256(salt + senha) em hex.
  final String passwordHash;

  /// Salt aleatório de 16 bytes, em hex.
  final String salt;

  final DateTime createdAt;
  DateTime lastLoginAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'username_lc': username.toLowerCase(),
        'email': email,
        'player_id': playerId.formatted,
        'password_hash': passwordHash,
        'salt': salt,
        'created_at': createdAt.millisecondsSinceEpoch,
        'last_login_at': lastLoginAt.millisecondsSinceEpoch,
      };

  factory Account.fromMap(Map<String, Object?> m) => Account(
        id: m['id'] as String,
        username: m['username'] as String,
        email: (m['email'] as String?) ?? '',
        playerId: PlayerId.parse(m['player_id'] as String),
        passwordHash: m['password_hash'] as String,
        salt: m['salt'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (m['created_at'] as int?) ?? 0),
        lastLoginAt: DateTime.fromMillisecondsSinceEpoch(
            (m['last_login_at'] as int?) ?? 0),
      );
}

/// Resultado de uma tentativa de auth.
class AuthResult {
  AuthResult({required this.success, this.account, this.error});

  final bool success;
  final Account? account;
  final String? error;

  factory AuthResult.ok(Account a) => AuthResult(success: true, account: a);
  factory AuthResult.fail(String reason) =>
      AuthResult(success: false, error: reason);
}
