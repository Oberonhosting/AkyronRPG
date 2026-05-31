import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'marketplace_store.dart';
import 'session.dart';
import 'world_state.dart';

/// Servidor multiplayer do Akyron.
///
/// Expõe:
/// - HTTP `GET  /info`            — descritor para clients pingarem
/// - HTTP `GET  /market/listings` — lista ofertas globais
/// - HTTP `POST /market/post`     — posta uma oferta
/// - HTTP `GET  /worldboss`       — estado do boss mundial
/// - WS   `/socket`               — sessão tempo real (chat, posições,
///                                  boss attack, party invites)
class AkyronServer {
  AkyronServer({
    this.host = '0.0.0.0',
    this.port = 28960,
    this.kind = 'public',
    this.name = 'Akyron — sem nome',
    this.password = '',
    this.maxPlayers = 200,
    this.antiCheat = true,
  });

  final String host;
  final int port;
  final String kind;
  final String name;
  final String password;
  final int maxPlayers;
  final bool antiCheat;

  HttpServer? _http;
  final SessionRegistry sessions = SessionRegistry();
  final MarketplaceStore market = MarketplaceStore();
  final WorldState world = WorldState();

  Future<void> start() async {
    final router = Router()
      ..get('/info', _info)
      ..get('/market/listings', _listListings)
      ..post('/market/post', _postListing)
      ..get('/worldboss', _worldBoss)
      ..get('/socket', webSocketHandler(_onSocket));

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    _http = await shelf_io.serve(handler, host, port);
  }

  Future<void> stop() async {
    await _http?.close(force: true);
    _http = null;
  }

  // ───────────── HTTP handlers ─────────────
  Response _info(Request req) {
    return Response.ok(
      jsonEncode({
        'name': name,
        'kind': kind,
        'players': sessions.count,
        'max': maxPlayers,
        'requires_password': password.isNotEmpty,
        'anti_cheat': antiCheat,
        'version': '0.1.0',
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  Response _listListings(Request req) {
    return Response.ok(
      jsonEncode({'listings': market.listAll()}),
      headers: {'content-type': 'application/json'},
    );
  }

  Future<Response> _postListing(Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final id = market.add(body);
      return Response.ok(jsonEncode({'ok': true, 'id': id}));
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'ok': false, 'error': '$e'}));
    }
  }

  Response _worldBoss(Request req) {
    return Response.ok(
      jsonEncode(world.bossSnapshot()),
      headers: {'content-type': 'application/json'},
    );
  }

  // ───────────── WebSocket ─────────────
  Future<void> _onSocket(WebSocketChannel ws, String? subprotocol) async {
    if (sessions.count >= maxPlayers) {
      ws.sink.add(jsonEncode({'t': 'reject', 'd': {'reason': 'full'}}));
      await ws.sink.close();
      return;
    }
    final sess = sessions.create(ws);
    ws.sink.add(jsonEncode({
      't': 'welcome',
      'd': {
        'sid': sess.id,
        'server': name,
        'world_boss': world.bossSnapshot(),
      },
    }));

    ws.stream.listen(
      (raw) => _handlePacket(sess, raw as String),
      onDone: () => sessions.remove(sess.id),
      onError: (_) => sessions.remove(sess.id),
    );
  }

  void _handlePacket(PlayerSession sess, String raw) {
    try {
      final p = jsonDecode(raw) as Map<String, dynamic>;
      final t = p['t'] as String?;
      final d = (p['d'] as Map?)?.cast<String, dynamic>() ?? const {};
      switch (t) {
        case 'hello':
          sess.handle = d['name'] as String?;
          sess.playerId = d['pid'] as String?;
          if (password.isNotEmpty && d['password'] != password) {
            sess.send({'t': 'reject', 'd': {'reason': 'bad_password'}});
            sess.close();
          }
          break;
        case 'pos':
          // Retransmite a posição para todos os outros — simples broadcast.
          sessions.broadcastExcept(sess.id, {'t': 'pos', 'd': {
            'sid': sess.id, ...d,
          }});
          break;
        case 'chat':
          sessions.broadcast({'t': 'chat', 'd': {
            'from': sess.handle ?? 'anon',
            'text': d['text'],
          }});
          break;
        case 'worldBossHit':
          final dmg = (d['dmg'] as int?) ?? 0;
          world.damageBoss(dmg);
          sessions.broadcast({'t': 'worldBoss', 'd': world.bossSnapshot()});
          break;
        case 'ping':
          sess.send({'t': 'pong', 'd': {'ts': d['ts']}});
          break;
        case 'bye':
          sess.close();
          break;
      }
    } catch (_) {
      // pacote malformado — ignora.
    }
  }
}
