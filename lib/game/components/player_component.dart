import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../models/character.dart';
import '../../models/enums.dart';

/// Avatar do jogador no mapa top-down. Pixel-art real será conectada
/// depois; por enquanto este componente desenha uma silhueta com camadas
/// para cabeça, corpo, manto e aura — todas pintadas conforme o loadout.
class PlayerComponent extends PositionComponent {
  PlayerComponent({required this.character, Vector2? position})
      : super(
          position: position ?? Vector2.zero(),
          size: Vector2(24, 32),
          anchor: Anchor.center,
        );

  final Character character;

  Vector2 velocity = Vector2.zero();
  double moveSpeed = 80;

  late final _AuraComponent _aura;
  bool _moving = false;

  @override
  Future<void> onLoad() async {
    _aura = _AuraComponent(
      color: AkyronTheme.systemAura[character.power.system.auraKey] ??
          AkyronTheme.violetArcane,
      radius: 22,
    );
    add(_aura);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (velocity.length2 > 0) {
      position += velocity.normalized() * moveSpeed * dt;
      _moving = true;
    } else {
      _moving = false;
    }
  }

  /// Pequeno feedback de "respirar" usado nos diálogos.
  void breatheIn() {
    add(
      SequenceEffect([
        ScaleEffect.by(Vector2.all(1.06), EffectController(duration: 0.2)),
        ScaleEffect.by(Vector2.all(1 / 1.06), EffectController(duration: 0.2)),
      ]),
    );
  }

  @override
  void render(Canvas canvas) {
    final tone = _toneFor(character.appearance.skinTone);
    final hair = character.appearance.hairColor;
    final cloakColor =
        character.loadout.get(EquipSlot.cloak)?.tintMain ?? const Color(0xFF101020);
    final topColor =
        character.loadout.get(EquipSlot.top)?.tintMain ?? const Color(0xFF3A1B5C);
    final hasCloak = character.loadout.get(EquipSlot.cloak) != null;

    // Sombra no chão.
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(12, 30), width: 18, height: 5),
      Paint()..color = Colors.black.withOpacity(0.35),
    );
    // Manto desenhado atrás.
    if (hasCloak) {
      final cloak = Paint()..color = cloakColor;
      final path = Path()
        ..moveTo(4, 14)
        ..quadraticBezierTo(12, 28, 20, 14)
        ..lineTo(22, 30)
        ..lineTo(2, 30)
        ..close();
      canvas.drawPath(path, cloak);
    }
    // Pernas.
    canvas.drawRect(
      const Rect.fromLTWH(8, 22, 8, 8),
      Paint()..color = const Color(0xFF1A1A2A),
    );
    // Corpo / topo (corset, kimono, armadura).
    canvas.drawRect(
      const Rect.fromLTWH(6, 12, 12, 12),
      Paint()..color = topColor,
    );
    // Acento dourado/colorido na borda do topo.
    final topAccent =
        character.loadout.get(EquipSlot.top)?.tintAccent ?? const Color(0xFFE8C547);
    canvas.drawRect(
      const Rect.fromLTWH(6, 11, 12, 1),
      Paint()..color = topAccent,
    );
    // Cabeça.
    canvas.drawOval(
      const Rect.fromLTWH(7, 2, 10, 12),
      Paint()..color = tone,
    );
    // Cabelo.
    canvas.drawArc(
      const Rect.fromLTWH(6, 1, 12, 10),
      3.14, 3.14, true,
      Paint()..color = hair,
    );
    // Chapéu / capacete se houver.
    final head = character.loadout.get(EquipSlot.head);
    if (head != null) {
      canvas.drawRect(
        const Rect.fromLTWH(5, 0, 14, 4),
        Paint()..color = head.tintMain,
      );
    }
    if (_moving) {
      canvas.drawCircle(
        const Offset(12, 31),
        2,
        Paint()..color = Colors.white.withOpacity(0.25),
      );
    }
  }

  Color _toneFor(double t) {
    final tones = [
      const Color(0xFFFFE0B5),
      const Color(0xFFE8C39E),
      const Color(0xFFC99878),
      const Color(0xFFA77150),
      const Color(0xFF7A4C2E),
      const Color(0xFF4B2A14),
    ];
    final i = (t * (tones.length - 1)).round().clamp(0, tones.length - 1);
    return tones[i];
  }
}

class _AuraComponent extends PositionComponent {
  _AuraComponent({required this.color, required this.radius})
      : super(anchor: Anchor.center);

  final Color color;
  final double radius;
  double _t = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
  }

  @override
  void render(Canvas canvas) {
    final pulse = 1.0 + 0.08 * ((_t * 2) % 1);
    final paint = Paint()
      ..color = color.withOpacity(0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(12, 18), radius * pulse, paint);
  }
}
