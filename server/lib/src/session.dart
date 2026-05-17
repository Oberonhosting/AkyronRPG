import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Sessão tempo-real de um jogador conectado.
class PlayerSession {
  PlayerSession({required this.id, required this.ws});

  final String id;
  final WebSocketChannel ws;

  String? handle;
  String? playerId;

  void send(Map<String, dynamic> packet) {
    try {
      ws.sink.add(jsonEncode(packet));
    } catch (_) {/* socket morto */}
  }

  Future<void> close() async {
    try {
      await ws.sink.close();
    } catch (_) {}
  }
}

class SessionRegistry {
  final Map<String, PlayerSession> _sessions = {};

  int get count => _sessions.length;
  Iterable<PlayerSession> get all => _sessions.values;

  PlayerSession create(WebSocketChannel ws) {
    final s = PlayerSession(id: const Uuid().v4(), ws: ws);
    _sessions[s.id] = s;
    return s;
  }

  void remove(String id) => _sessions.remove(id);

  void broadcast(Map<String, dynamic> packet) {
    for (final s in _sessions.values) {
      s.send(packet);
    }
  }

  void broadcastExcept(String exceptId, Map<String, dynamic> packet) {
    for (final s in _sessions.values) {
      if (s.id == exceptId) continue;
      s.send(packet);
    }
  }
}
