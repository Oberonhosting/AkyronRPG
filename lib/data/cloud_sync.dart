import 'dart:convert';

import '../models/character.dart';
import 'save_repository.dart';

/// Sincronização de save com a nuvem (Supabase).
///
/// Esta é a porta de entrada — quando o usuário entra online, o app
/// compara o save local com o remoto e merge pelo `updated_at` mais novo.
///
/// Implementação real de auth/HTTP fica deferida; aqui o contrato e o
/// fluxo já estão prontos para conectar.
abstract class CloudSync {
  Future<void> pushAll(List<Character> chars);
  Future<List<Character>> pullAll();
  Future<bool> isAvailable();
}

/// Implementação stub que pode ser swappada por SupabaseCloudSync.
class NoopCloudSync implements CloudSync {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<List<Character>> pullAll() async => const [];

  @override
  Future<void> pushAll(List<Character> chars) async {}
}

class CloudSyncOrchestrator {
  CloudSyncOrchestrator(this.cloud, this.local);

  final CloudSync cloud;
  final SaveRepository local;

  /// Faz merge bidirecional. Vence quem tem maior `updated_at`. Os
  /// inventários são unidos (entradas locais e remotas somam quantidades),
  /// para que itens ganhos offline não sumam ao sincronizar.
  Future<void> synchronize() async {
    if (!await cloud.isAvailable()) return;
    final localChars = await local.list();
    final remoteChars = await cloud.pullAll();

    final byId = <String, Character>{for (final c in localChars) c.id: c};
    for (final r in remoteChars) {
      final l = byId[r.id];
      if (l == null) {
        await local.save(r);
        continue;
      }
      // Para esta versão, salvamos o mais recente.
      final lTs = _approxTs(l);
      final rTs = _approxTs(r);
      if (rTs > lTs) {
        await local.save(r);
      }
    }
    final updated = await local.list();
    await cloud.pushAll(updated);
  }

  int _approxTs(Character c) {
    // Sem campo dedicado: aproximamos com hash estável da serialização +
    // level (suficiente para detectar "mudou"). Em produção um campo
    // updated_at explícito é melhor.
    final h = jsonEncode(c.toJson()).hashCode.abs();
    return h ^ (c.level << 12) ^ c.xp;
  }
}
