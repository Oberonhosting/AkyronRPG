import 'dart:convert';

import '../models/character.dart';

/// Hash não-criptográfico (FNV-1a 64 bits). Em produção, troque por
/// `sha256` do `package:crypto`. Para o nível de detecção de save adulterado
/// pretendido aqui, FNV é suficiente.
class _FnvHash {
  static String hex(String input) {
    var h = BigInt.parse('cbf29ce484222325', radix: 16);
    final mask = BigInt.parse('ffffffffffffffff', radix: 16);
    final prime = BigInt.parse('100000001b3', radix: 16);
    for (final code in utf8.encode(input)) {
      h = (h ^ BigInt.from(code)) & mask;
      h = (h * prime) & mask;
    }
    return h.toRadixString(16).padLeft(16, '0');
  }
}

/// Checagens básicas anti-cheat. Servidores aprovados (premium) executam
/// estes antes de aceitar packets críticos. Servidores "free/lixo" pulam.
class AntiCheat {
  AntiCheat._();

  /// Hash determinístico do estado essencial do personagem. Usado pelo
  /// servidor para detectar saves alterados manualmente.
  static String checksum(Character c) {
    final core = <String, dynamic>{
      'lvl': c.level,
      'rank': c.rank.name,
      'sys': c.power.system.name,
      'el': c.power.element.name,
      'hp': c.baseStats.maxHp,
      'atk': c.baseStats.attack,
      'spi': c.baseStats.spirit,
    };
    return _FnvHash.hex(jsonEncode(core));
  }

  /// Validação leve: stats não podem ultrapassar limites por level.
  static bool sanityOk(Character c) {
    if (c.level < 1 || c.level > 120) return false;
    final cap = 60 + c.level * 6;
    if (c.baseStats.attack > cap) return false;
    if (c.baseStats.spirit > cap) return false;
    if (c.baseStats.maxHp > 100 + c.level * 25) return false;
    return true;
  }
}
