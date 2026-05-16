import 'dart:convert';

/// Tipos de mensagem trocadas entre cliente e servidor.
enum PacketType {
  hello,           // handshake inicial: id do jogador + versão do client
  welcome,         // servidor → cliente: confirmação + spawn point
  pos,             // posição/visual do jogador no mapa
  chat,            // mensagem de chat
  partyInvite,     // convite de party
  partyAccept,
  combatStart,     // boss/encontro disparado
  combatAction,
  worldBoss,       // tick do boss mundial
  ping,
  pong,
  bye,
}

/// Pacote serializável.
class Packet {
  Packet({required this.type, this.data = const {}, this.ts});

  final PacketType type;
  final Map<String, dynamic> data;
  final int? ts;

  String encode() => jsonEncode({
        't': type.name,
        'd': data,
        'ts': ts ?? DateTime.now().millisecondsSinceEpoch,
      });

  static Packet decode(String raw) {
    final m = jsonDecode(raw) as Map<String, dynamic>;
    return Packet(
      type: PacketType.values.firstWhere((t) => t.name == m['t']),
      data: (m['d'] as Map?)?.cast<String, dynamic>() ?? const {},
      ts: m['ts'] as int?,
    );
  }
}
