import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../akyron_game.dart';

/// Configura um joystick virtual para mobile no canto inferior esquerdo.
JoystickComponent buildMobileJoystick(AkyronGame game) {
  final knob = CircleComponent(
    radius: 24,
    paint: Paint()..color = const Color(0xCCE8C547),
  );
  final bg = CircleComponent(
    radius: 56,
    paint: Paint()..color = const Color(0x33141228),
  );
  final joy = JoystickComponent(
    knob: knob,
    background: bg,
    margin: const EdgeInsets.only(left: 32, bottom: 32),
  );
  joy.addToParent(game.camera.viewport);
  return joy;
}

/// Chamado a cada frame pelo widget pai para alimentar o player.
void feedAxisFromJoystick(JoystickComponent joy, AkyronGame game) {
  game.setMoveAxis(joy.relativeDelta * 1.0);
}
