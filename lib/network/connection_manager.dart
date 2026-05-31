import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/character.dart';
import 'packet.dart';
import 'server_types.dart';

/// Wrapper de WebSocket por servidor — envia/recebe Packets.
class Connection {
  Connection._(this.server, this._channel);

  final ServerDescriptor server;
  final WebSocketChannel _channel;

  final _incoming = StreamController<Packet>.broadcast();
  Stream<Packet> get incoming => _incoming.stream;

  bool _disposed = false;

  static Future<Connection> open(
    ServerDescriptor s, {
    required Character avatar,
  }) async {
    final uri = Uri.parse('ws://${s.host}:${s.port}');
    final channel = WebSocketChannel.connect(uri);
    final c = Connection._(s, channel);
    c._listen();
    c.send(Packet(type: PacketType.hello, data: {
      'pid': avatar.playerId.formatted,
      'name': avatar.displayName,
      'power': avatar.power.system.name,
      'visual': avatar.power.visualId,
      'password': s.password,
    }));
    return c;
  }

  void send(Packet p) {
    if (_disposed) return;
    _channel.sink.add(p.encode());
  }

  void _listen() {
    _channel.stream.listen(
      (raw) {
        try {
          _incoming.add(Packet.decode(raw as String));
        } catch (e) {
          // mensagem malformada — ignora.
        }
      },
      onDone: () => close(),
      onError: (_) => close(),
    );
  }

  Future<void> close() async {
    if (_disposed) return;
    _disposed = true;
    try {
      send(Packet(type: PacketType.bye));
      await _channel.sink.close();
    } catch (_) {}
    await _incoming.close();
  }
}
