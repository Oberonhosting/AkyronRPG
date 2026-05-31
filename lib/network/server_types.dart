import '../core/constants.dart';
import '../models/enums.dart';

/// Descritor de um servidor (público, privado, free/lixo ou premium).
class ServerDescriptor {
  ServerDescriptor({
    required this.id,
    required this.name,
    required this.kind,
    required this.host,
    this.port = AkyronK.defaultPort,
    this.password,
    this.region = 'global',
    this.tags = const [],
    this.maxPlayers = AkyronK.maxServerPlayers,
    this.players = 0,
    this.moderated = false,
    this.antiCheat = false,
    this.ping = 0,
  });

  final String id;
  final String name;
  final ServerKind kind;
  final String host;
  final int port;
  final String? password;
  final String region;
  final List<String> tags;
  final int maxPlayers;

  /// Atualizados pelo listing/heartbeat.
  int players;
  bool moderated;
  bool antiCheat;
  int ping;

  bool get requiresPassword => password != null && password!.isNotEmpty;
  bool get isOnline => kind != ServerKind.offline;

  String get badge => switch (kind) {
        ServerKind.publicWorld => '🌐 Público',
        ServerKind.privateRoom => '🔒 Privado',
        ServerKind.freeJunk => '💨 Free/Lixo',
        ServerKind.premiumApproved => '⭐ Premium',
        ServerKind.offline => '📴 Offline',
      };
}
