import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:little_engine/little_engine.dart';

class SpriteObject extends GameComponent {
  Sprite sprite;

  @override
  void render(Canvas canvas, Offset offset) {
    if (sprite != null && position != null && sprite.loaded) sprite.renderRect(canvas, position);
  }

  @override
  int get priority => PriorityLayer.OBJECTS;
}
