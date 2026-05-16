import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;

import '../models/character.dart';
import 'components/player_component.dart';
import 'components/tile_map.dart';
import 'world/region.dart';
import 'world/weather.dart';

/// Game root do Flame — controla mapa, jogador, clima e câmera.
class AkyronGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  AkyronGame({required this.character});

  final Character character;

  late PlayerComponent player;
  late Region currentRegion;
  final weather = WeatherSystem();

  @override
  Future<void> onLoad() async {
    currentRegion = WorldRegions.byId(character.region);

    final map = GeneratedTileMap(
      region: currentRegion,
      tileSize: 24,
      cols: 64,
      rows: 64,
    );
    await world.add(map);

    player = PlayerComponent(
      character: character,
      position: Vector2(map.size.x / 2, map.size.y / 2),
    );
    await world.add(player);

    camera.viewfinder.zoom = 2.5;
    camera.follow(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    weather.maybeRotate(currentRegion.weatherPresets);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    final dx = (keys.contains(LogicalKeyboardKey.arrowRight) ||
                keys.contains(LogicalKeyboardKey.keyD)
            ? 1.0
            : 0.0) -
        (keys.contains(LogicalKeyboardKey.arrowLeft) ||
                keys.contains(LogicalKeyboardKey.keyA)
            ? 1.0
            : 0.0);
    final dy = (keys.contains(LogicalKeyboardKey.arrowDown) ||
                keys.contains(LogicalKeyboardKey.keyS)
            ? 1.0
            : 0.0) -
        (keys.contains(LogicalKeyboardKey.arrowUp) ||
                keys.contains(LogicalKeyboardKey.keyW)
            ? 1.0
            : 0.0);
    player.velocity = Vector2(dx, dy);
    return KeyEventResult.handled;
  }

  /// Joystick virtual para mobile chama isto.
  void setMoveAxis(Vector2 axis) {
    player.velocity = axis;
  }
}
