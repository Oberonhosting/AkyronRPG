import 'dart:async';
import 'dart:math';

import 'package:uuid/uuid.dart';

import '../models/enums.dart';
import 'server_types.dart';

/// Gerencia descoberta de servidores e seleção.
///
/// Em produção isto consulta um diretório central (Supabase). Aqui o
/// fallback popula com servidores aprovados (oficiais) + alguns "free/lixo"
/// para o jogador experimentar mesmo offline.
class ServerManager {
  ServerManager({Random? rng}) : _rng = rng ?? Random();

  final Random _rng;
  final _ctrl = StreamController<List<ServerDescriptor>>.broadcast();
  final List<ServerDescriptor> _cache = [];

  Stream<List<ServerDescriptor>> get servers => _ctrl.stream;

  Future<List<ServerDescriptor>> refresh() async {
    _cache
      ..clear()
      ..addAll(_premiumApproved())
      ..addAll(_publicWorlds())
      ..addAll(_freeJunk());
    _ctrl.add(List.unmodifiable(_cache));
    return List.unmodifiable(_cache);
  }

  /// Cria um servidor privado com senha — registrado no diretório local.
  ServerDescriptor createPrivate({
    required String name,
    required String host,
    required String password,
    int? port,
  }) {
    final s = ServerDescriptor(
      id: const Uuid().v4(),
      name: name,
      kind: ServerKind.privateRoom,
      host: host,
      port: port ?? 28960,
      password: password,
      moderated: false,
      antiCheat: false,
      ping: _rng.nextInt(120),
    );
    _cache.add(s);
    _ctrl.add(List.unmodifiable(_cache));
    return s;
  }

  // ───────────────────────── Seeds locais ─────────────────────────
  List<ServerDescriptor> _premiumApproved() => [
        ServerDescriptor(
          id: 'premium.akyron.global',
          name: 'Akyron Premium — Global',
          kind: ServerKind.premiumApproved,
          host: 'premium.akyron.example',
          region: 'global',
          tags: const ['oficial', 'ranqueado', 'estável'],
          moderated: true,
          antiCheat: true,
          players: 120 + _rng.nextInt(60),
          ping: 28 + _rng.nextInt(40),
        ),
        ServerDescriptor(
          id: 'premium.akyron.br',
          name: 'Akyron Premium — Brasil',
          kind: ServerKind.premiumApproved,
          host: 'premium-br.akyron.example',
          region: 'br',
          tags: const ['oficial', 'ranqueado', 'estável'],
          moderated: true,
          antiCheat: true,
          players: 80 + _rng.nextInt(40),
          ping: 18 + _rng.nextInt(20),
        ),
      ];

  List<ServerDescriptor> _publicWorlds() => [
        ServerDescriptor(
          id: 'public.world.001',
          name: 'Mundo Aberto — Floresta Arcana',
          kind: ServerKind.publicWorld,
          host: 'world1.akyron.example',
          region: 'global',
          tags: const ['boss-mundial', 'pve'],
          moderated: true,
          players: 70 + _rng.nextInt(80),
          ping: 35 + _rng.nextInt(50),
        ),
        ServerDescriptor(
          id: 'public.world.002',
          name: 'Mundo Aberto — Terras Amaldiçoadas',
          kind: ServerKind.publicWorld,
          host: 'world2.akyron.example',
          region: 'global',
          tags: const ['pvp', 'noturno'],
          moderated: true,
          players: 40 + _rng.nextInt(60),
          ping: 40 + _rng.nextInt(60),
        ),
      ];

  List<ServerDescriptor> _freeJunk() => [
        ServerDescriptor(
          id: 'free.junk.001',
          name: 'Espinho-de-Estrela [free]',
          kind: ServerKind.freeJunk,
          host: 'junk1.akyron.example',
          tags: const ['rápido', 'sem moderação'],
          players: 8 + _rng.nextInt(20),
          ping: 80 + _rng.nextInt(180),
        ),
        ServerDescriptor(
          id: 'free.junk.002',
          name: 'Sala dos Caçadores [free]',
          kind: ServerKind.freeJunk,
          host: 'junk2.akyron.example',
          tags: const ['casual', 'experimental'],
          players: 12 + _rng.nextInt(25),
          ping: 95 + _rng.nextInt(150),
        ),
      ];

  void dispose() => _ctrl.close();
}
