import 'package:shared_preferences/shared_preferences.dart';

import 'auth_models.dart';
import 'auth_repository.dart';

/// Sessão persistente do jogador.
///
/// Regra: o login fica salvo no dispositivo até a pessoa fazer logout
/// **ou** ficar 30 dias sem abrir o jogo. Cada `restore()` atualiza o
/// timestamp, então quem joga regularmente nunca precisa logar de novo.
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  static const String _keyAccountId = 'akyron.session.account_id';
  static const String _keyLastSeen = 'akyron.session.last_seen';
  static const Duration _maxInactivity = Duration(days: 30);

  Account? _current;

  Account? get currentAccount => _current;
  bool get isLoggedIn => _current != null;

  /// Recupera a sessão do disco. Retorna a Account se válida (não
  /// expirada e usuário ainda existe), ou null caso contrário.
  Future<Account?> restore({required AuthRepository auth}) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyAccountId);
    final lastSeenMs = prefs.getInt(_keyLastSeen);
    if (id == null || lastSeenMs == null) return null;

    final lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenMs);
    if (DateTime.now().difference(lastSeen) > _maxInactivity) {
      await clear();
      return null;
    }

    final acc = await auth.getById(id);
    if (acc == null) {
      await clear();
      return null;
    }
    _current = acc;
    await _touch(prefs);
    return acc;
  }

  /// Persiste a sessão após login/registro bem-sucedido.
  Future<void> persist(Account account) async {
    _current = account;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccountId, account.id);
    await _touch(prefs);
  }

  /// Atualiza apenas o `last_seen` — chame periodicamente enquanto
  /// joga, para estender a janela de 30 dias.
  Future<void> heartbeat() async {
    if (_current == null) return;
    final prefs = await SharedPreferences.getInstance();
    await _touch(prefs);
  }

  /// Encerra a sessão (logout manual ou expirada).
  Future<void> clear() async {
    _current = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccountId);
    await prefs.remove(_keyLastSeen);
  }

  Future<void> _touch(SharedPreferences prefs) async {
    await prefs.setInt(_keyLastSeen, DateTime.now().millisecondsSinceEpoch);
  }
}
