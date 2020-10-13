import 'package:bonfire/bonfire.dart';
import 'package:example/map/dungeon_map.dart';
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart';

class Torch extends GameDecoration with Lighting {
  Torch(LEPosition position)
      : super.animation(
          LEFrameAnimation.sequenced(
            "itens/torch_spritesheet.png",
            6,
            textureWidth: 16,
            textureHeight: 16,
          ),
          width: DungeonMap.tileSize,
          height: DungeonMap.tileSize,
          initPosition: position,
        ) {
    lightingConfig = LightingConfig(
      radius: width * 1.5,
      blurBorder: width * 1.5,
      color: Colors.deepOrangeAccent.withOpacity(0.2),
    );
  }
}
