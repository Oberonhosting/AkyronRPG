import 'package:intl/intl.dart';

/// Moeda do mundo de Akyron.
///
/// Lascas de Éon (LE) — fragmentos do Rio que vazou na Fratura. Caem em
/// combate, missões, dungeons e drops raros. Você usa pra comprar roupas,
/// inscrever em torneios, alugar slots de servidor privado.
///
/// Visualmente: pequenas lascas hexagonais brilhando em violeta-dourado.
class Currency {
  Currency._();

  /// Nome canônico — aparece em UI e diálogos.
  static const String name = 'Lasca de Éon';
  static const String namePlural = 'Lascas de Éon';
  static const String symbol = 'LE';

  /// Formata um valor com separador de milhares no padrão pt-BR.
  /// 1 → "1 LE"  |  12345 → "12.345 LE"
  static String format(int amount) {
    final f = NumberFormat.decimalPattern('pt_BR');
    return '${f.format(amount)} $symbol';
  }

  /// Versão longa para diálogos: "12.345 Lascas de Éon".
  static String formatLong(int amount) {
    final f = NumberFormat.decimalPattern('pt_BR');
    final label = amount == 1 ? name : namePlural;
    return '${f.format(amount)} $label';
  }
}
