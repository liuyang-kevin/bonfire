import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:example/decoration/barrel_dragable.dart';
import 'package:example/decoration/chest.dart';
import 'package:example/decoration/spikes.dart';
import 'package:example/decoration/torch.dart';
import 'package:example/enemy/goblin.dart';
import 'package:example/interface/knight_interface.dart';
import 'package:example/map/dungeon_map.dart';
import 'package:example/player/knight.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart' hide JoystickDirectional, JoystickAction, JoystickActionAlign;

class GameTiledMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DungeonMap.tileSize = max(constraints.maxHeight, constraints.maxWidth) / (kIsWeb ? 25 : 22);
        return BonfireTiledWidget(
          joystick: Joystick(
            keyboardEnable: true,
            directional: JoystickDirectional(
              spriteBackgroundDirectional: Sprite('joystick_background.png'),
              spriteKnobDirectional: Sprite('joystick_knob.png'),
              size: 100,
              isFixed: false,
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
          player: Knight(LEPosition((8 * DungeonMap.tileSize), (5 * DungeonMap.tileSize))),
          interface: KnightInterface(),
          map: TiledWorldMap(
            'tiled/mapa1.json',
            forceTileSize: Size(DungeonMap.tileSize, DungeonMap.tileSize),
          )
            ..registerObject('goblin', (x, y, width, height) => Goblin(LEPosition(x, y)))
            ..registerObject('torch', (x, y, width, height) => Torch(LEPosition(x, y)))
            ..registerObject('barrel', (x, y, width, height) => BarrelDraggable(LEPosition(x, y)))
            ..registerObject('spike', (x, y, width, height) => Spikes(LEPosition(x, y)))
            ..registerObject('chest', (x, y, width, height) => Chest(LEPosition(x, y))),
          background: BackgroundColorGame(Colors.blueGrey[900]),
          lightingColorGame: Colors.black.withOpacity(0.5),
          cameraZoom: 1.0, // you can change the game zoom here or directly on camera
        );
      },
    );
  }
}
