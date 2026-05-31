import 'dart:math';

/// Gera o ID público #Nome0000 usado para adicionar amigos e convites.
class PlayerId {
  PlayerId(this.handle, this.tag);

  /// Constrói a partir de um nome digitado. O tag (4 dígitos) é aleatório.
  factory PlayerId.fromName(String name, {Random? rng}) {
    final r = rng ?? Random.secure();
    final clean = _sanitize(name);
    final tag = (r.nextInt(9000) + 1000).toString();
    return PlayerId(clean, tag);
  }

  /// Reconstrói a partir de uma string "#Yami4521".
  factory PlayerId.parse(String raw) {
    final s = raw.startsWith('#') ? raw.substring(1) : raw;
    if (s.length < 5) throw const FormatException('ID inválido');
    final tag = s.substring(s.length - 4);
    final handle = s.substring(0, s.length - 4);
    if (int.tryParse(tag) == null) {
      throw const FormatException('Tag precisa ser 4 dígitos');
    }
    return PlayerId(handle, tag);
  }

  final String handle;
  final String tag;

  String get formatted => '#$handle$tag';

  @override
  String toString() => formatted;

  @override
  bool operator ==(Object other) =>
      other is PlayerId && other.handle == handle && other.tag == tag;

  @override
  int get hashCode => Object.hash(handle, tag);

  static String _sanitize(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return 'Wanderer';
    // Capitaliza e remove tudo que não for letra/dígito; máx 12 chars.
    final cleaned = trimmed.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final cut = cleaned.substring(0, cleaned.length.clamp(0, 12));
    if (cut.isEmpty) return 'Wanderer';
    return cut[0].toUpperCase() + cut.substring(1).toLowerCase();
  }
}
