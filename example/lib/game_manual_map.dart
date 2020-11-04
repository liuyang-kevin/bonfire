import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/game_controller.dart';
import 'package:example/enemy/goblin.dart';
import 'package:example/map/dungeon_map.dart';
import 'package:example/player/knight.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart';

import 'interface/knight_interface.dart';

class GameManualMap extends StatelessWidget implements GameListener {
  final GameController _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      DungeonMap.tileSize = max(constraints.maxHeight, constraints.maxWidth) / (kIsWeb ? 25 : 22);
      return BonfireWidget(
        joystick: JoystickComp(
          //keyboardEnable: true,
          directional: JoystickDirectional(
            spriteBackgroundDirectional: Sprite('joystick_background.png'),
            spriteKnobDirectional: Sprite('joystick_knob.png'),
            size: 100,
            isFixed: true,
          ),
          actions: [
            JoystickAction(
              actionId: 0,
              sprite: Sprite('joystick_atack.png'),
              align: JoystickActionAlign.BOTTOM_RIGHT,
              size: 80,
              margin: EdgeInsets.only(bottom: 50, right: 50),
            ),
            JoystickAction(
              actionId: 1,
              sprite: Sprite('joystick_atack_range.png'),
              spriteBackgroundDirection: Sprite('joystick_background.png'),
              enableDirection: true,
              size: 50,
              margin: EdgeInsets.only(bottom: 50, right: 160),
            )
          ],
        ),
        player: Knight(
          LEPosition((4 * DungeonMap.tileSize), (6 * DungeonMap.tileSize)),
        ),
        interface: KnightInterface(), // 骑士相关UI,游戏相关UI
        map: DungeonMap.map(),
        enemies: DungeonMap.enemies(),
        decorations: DungeonMap.decorations(),
        background: BackgroundColorGame(Colors.blue[900]),
        gameController: _controller..setListener(this),
        lightingColorGame: Colors.black.withOpacity(0.75),
        cameraZoom: 1.0, // you can change the game zoom here or directly on camera
      );
    });
  }

  @override
  void updateGame() {}

  @override
  void changeCountLiveEnemies(int count) {
    if (count < 2) {
      _addEnemyInWorld();
    }
  }

  /// 添加敌人
  void _addEnemyInWorld() {
    double x = DungeonMap.tileSize * (4 + Random().nextInt(25));
    double y = DungeonMap.tileSize * (5 + Random().nextInt(3));

    LEPosition position = LEPosition(x, y);
    _controller.addGameComponent(
      AnimatedObjectOnce(
        animation: LEFrameAnimation.sequenced(
          "smoke_explosin.png",
          6,
          textureWidth: 16,
          textureHeight: 16,
        ),
        position: Rect.fromLTWH(
          position.x,
          position.y,
          DungeonMap.tileSize,
          DungeonMap.tileSize,
        ),
      ),
    );

    _controller.addGameComponent(
      Goblin(
        position,
      ),
    );
  }
}
