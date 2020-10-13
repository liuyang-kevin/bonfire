import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:bonfire/player/player.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:little_engine/little_engine.dart';

///
/// This represents a Component for your game in bonfire.
///
/// All components like [Enemy],[Player] and [GameDecoration] extends this.
class AnimatedObject extends GameComponent {
  /// Animation that will be drawn on the screen.
  LEFrameAnimation animation;

  @override
  void render(Canvas canvas, Offset offset) {
    super.render(canvas, offset);
    if (animation == null || position == null) return;
    if (animation.loaded) {
      animation.getSprite().renderRect(canvas, position);
    }
  }

  @override
  void update(double dt) {
    if (animation != null) animation.update(dt);
    super.update(dt);
  }

  @override
  int get priority => PriorityLayer.OBJECTS;
}
