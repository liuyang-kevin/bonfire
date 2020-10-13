import 'package:bonfire/bonfire.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:example/map/dungeon_map.dart';
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart';

class BarrelDraggable extends GameDecoration with DragGesture {
  TextConfig _textConfig;
  BarrelDraggable(LEPosition initPosition)
      : super.sprite(
          Sprite('itens/barrel.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
          collision: Collision(
            width: DungeonMap.tileSize * 0.6,
            height: DungeonMap.tileSize * 0.8,
            align: Offset(
              DungeonMap.tileSize * 0.2,
              0,
            ),
          ),
        ) {
    _textConfig = TextConfig(color: Colors.white, fontSize: width / 4);
  }

  @override
  void render(Canvas canvas, Offset offset) {
    super.render(canvas, offset);
    _textConfig.render(
      canvas,
      'Drag',
      LEPosition(this.position.left + width / 5, this.position.top - width / 3),
    );
  }
}
