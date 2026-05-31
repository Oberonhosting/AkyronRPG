import 'dart:io';

import 'package:akyron_server/akyron_server.dart';
import 'package:args/args.dart';

/// Entrypoint do servidor Akyron.
///
/// Uso:
///   dart run akyron_server:akyron_server --port 28960 --kind premium
///
/// Em produção pode rodar em qualquer VPS (Linux/Windows/macOS).
Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('host', defaultsTo: '0.0.0.0')
    ..addOption('port', defaultsTo: '28960')
    ..addOption('kind',
        defaultsTo: 'public',
        allowed: ['public', 'private', 'free', 'premium'],
        help: 'Tipo do servidor anunciado para clientes.')
    ..addOption('name', defaultsTo: 'Akyron — Servidor não nomeado')
    ..addOption('password', defaultsTo: '',
        help: 'Senha opcional para servidores privados.')
    ..addOption('max-players', defaultsTo: '200')
    ..addFlag('anticheat', defaultsTo: true);

  final cfg = parser.parse(args);
  final server = AkyronServer(
    host: cfg['host'] as String,
    port: int.parse(cfg['port'] as String),
    kind: cfg['kind'] as String,
    name: cfg['name'] as String,
    password: cfg['password'] as String,
    maxPlayers: int.parse(cfg['max-players'] as String),
    antiCheat: cfg['anticheat'] as bool,
  );

  await server.start();
  stdout.writeln('Akyron Server escutando em ${server.host}:${server.port}');
  stdout.writeln('Tipo: ${server.kind} • Jogadores máx: ${server.maxPlayers}');
  stdout.writeln('Pressione Ctrl+C para parar.');
}
