import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

/// 可角度旋转 的 玩家
///
/// 一个空闲状态 loop帧动画 + 一个移动帧动画,根据角度绘制玩家对象
class RotationPlayer extends Player {
  final LEFrameAnimation animIdle;
  final LEFrameAnimation animRun;
  double speed;
  double currentRadAngle;
  bool _move = false;
  LEFrameAnimation animation;

  RotationPlayer({
    @required LEPosition initPosition,
    @required this.animIdle,
    @required this.animRun,
    this.speed = 150,
    this.currentRadAngle = -1.55,
    double width = 32,
    double height = 32,
    double life = 100,
    Collision collision,
  }) : super(initPosition: initPosition, width: width, height: height, life: life, collision: collision) {
    this.animation = animIdle;
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional != JoystickMoveDirectional.IDLE && !isDead && event.radAngle != 0.0) {
      currentRadAngle = event.radAngle;
      _move = true;
      this.animation = animRun;
    } else {
      _move = false;
      this.animation = animIdle;
    }
    super.joystickChangeDirectional(event);
  }

  @override
  void update(double dt) {
    if (_move && !isDead) {
      moveFromAngle(speed, currentRadAngle);
    }
    animation?.update(dt);
    super.update(dt);
  }

  @override
  void render(Canvas canvas, Offset offset) {
    canvas.save();
    canvas.translate(position.center.dx, position.center.dy);
    canvas.rotate(currentRadAngle == 0.0 ? 0.0 : currentRadAngle + (pi / 2));
    canvas.translate(-position.center.dx, -position.center.dy);
    _renderAnimation(canvas);
    canvas.restore();
  }

  void _renderAnimation(Canvas canvas) {
    if (animation == null || position == null) return;
    if (animation.loaded) {
      animation.getSprite().renderRect(canvas, position);
    }
  }
}
