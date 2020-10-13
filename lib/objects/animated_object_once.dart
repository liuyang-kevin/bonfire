import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/lighting/lighting.dart';
import 'package:bonfire/lighting/lighting_config.dart';
import 'package:bonfire/objects/animated_object.dart';
import 'package:little_engine/little_engine.dart';

/// 一次性动画对象
class AnimatedObjectOnce extends AnimatedObject with Lighting {
  final VoidCallback onFinish;
  final VoidCallback onStartAnimation;
  final double rotateRadAngle;
  bool _notifyStart = false;
  final LightingConfig lightingConfig;

  AnimatedObjectOnce({
    Rect position,
    LEFrameAnimation animation,
    this.onFinish,
    this.onStartAnimation,
    this.rotateRadAngle,
    this.lightingConfig,
  }) {
    this.animation = animation..loop = false;
    this.position = position;
  }

  @override
  void render(Canvas canvas, Offset offset) {
    if (this.position == null) return;
    if (rotateRadAngle != null) {
      canvas.save();
      canvas.translate(position.center.dx, position.center.dy);
      canvas.rotate(rotateRadAngle == 0.0 ? 0.0 : rotateRadAngle + (pi / 2));
      canvas.translate(-position.center.dx, -position.center.dy);
      super.render(canvas, offset);
      canvas.restore();
    } else {
      super.render(canvas, offset);
    }
    if (animation.isLastFrame) {
      // 最后一帧就可以移除了
      if (onFinish != null) onFinish();
      remove();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animation != null && !willDestroy()) {
      if (animation.currentIndex == 1 && !_notifyStart) {
        _notifyStart = true;
        if (onStartAnimation != null) onStartAnimation();
      }
    }
  }
}
