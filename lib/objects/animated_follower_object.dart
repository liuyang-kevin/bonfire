import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/objects/follower_object.dart';
import 'package:little_engine/little_engine.dart';

class AnimatedFollowerObject extends FollowerObject {
  final GameComponent target;
  final Rect positionFromTarget;
  final bool loopAnimation;
  final LEFrameAnimation animation;

  AnimatedFollowerObject({
    this.animation,
    this.target,
    this.positionFromTarget,
    this.loopAnimation = false,
  });

  @override
  void render(Canvas canvas, Offset offset) {
    if (animation == null || position == null) return;
    if (animation.loaded) {
      animation.getSprite().renderRect(canvas, position);
    }
    super.render(canvas, offset);
  }

  @override
  void update(double dt) {
    animation?.update(dt);
    super.update(dt);
    if (!loopAnimation) {
      if (animation.isLastFrame) {
        remove();
      }
    }
  }
}
