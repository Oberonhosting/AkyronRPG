import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../world/region.dart';

/// Mapa procedural simples para a primeira região (placeholder pixel-art).
/// Quando os tilemaps Tiled estiverem prontos, este componente é
/// substituído pelo `TiledComponent`.
class GeneratedTileMap extends PositionComponent {
  GeneratedTileMap({
    required this.region,
    required this.tileSize,
    required this.cols,
    required this.rows,
    Random? rng,
  })  : _rng = rng ?? Random(region.id.hashCode),
        super(size: Vector2(tileSize * cols, tileSize * rows));

  final Region region;
  final double tileSize;
  final int cols;
  final int rows;
  final Random _rng;

  late final List<List<int>> _tiles = List.generate(
    rows,
    (_) => List.generate(cols, (_) => _rng.nextInt(4)),
  );

  @override
  void render(Canvas canvas) {
    final paints = _palette();
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final t = _tiles[r][c];
        final rect = Rect.fromLTWH(
          c * tileSize, r * tileSize, tileSize, tileSize,
        );
        canvas.drawRect(rect, paints[t]);
      }
    }
    // Tint atmosférico da região.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, cols * tileSize, rows * tileSize),
      Paint()..color = region.atmosphereTint,
    );
  }

  List<Paint> _palette() {
    final base = region.atmosphereTint.withOpacity(1.0);
    return [
      Paint()..color = const Color(0xFF1A1A2A),
      Paint()..color = const Color(0xFF22223A),
      Paint()..color = base.withOpacity(0.4),
      Paint()..color = const Color(0xFF2C2A45),
    ];
  }
}
