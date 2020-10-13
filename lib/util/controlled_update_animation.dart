import 'dart:ui';

import 'package:little_engine/little_engine.dart';

class ControlledUpdateAnimation {
  bool _alreadyUpdate = false;
  final LEFrameAnimation animation;

  ControlledUpdateAnimation(this.animation);

  void render(Canvas canvas, Rect position) {
    if (position == null) return;
    if (animation != null && animation.loaded) {
      animation.getSprite().renderRect(canvas, position);
    }
    _alreadyUpdate = false;
  }

  void update(double dt) {
    if (!_alreadyUpdate) {
      _alreadyUpdate = true;
      animation?.update(dt);
    }
  }
}
