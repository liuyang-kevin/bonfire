import 'dart:math';

import 'package:bonfire/enemy/enemy.dart';
import 'package:bonfire/util/collision/collision.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

class RotationEnemy extends Enemy {
  final LEFrameAnimation animIdle;
  final LEFrameAnimation animRun;

  LEFrameAnimation animation;

  /// Variable that represents the speed of the enemy.
  final double speed;
  double currentRadAngle;

  RotationEnemy({
    @required LEPosition initPosition,
    @required this.animIdle,
    @required this.animRun,
    double height = 32,
    double width = 32,
    this.currentRadAngle = -1.55,
    this.speed = 100,
    double life = 100,
    Collision collision,
  }) : super(initPosition: initPosition, height: height, width: width, life: life, collision: collision) {
    idle();
  }

  @override
  void moveFromAngleDodgeObstacles(double speed, double angle, {Function notMove}) {
    this.animation = animRun;
    currentRadAngle = angle;
    super.moveFromAngleDodgeObstacles(speed, angle, notMove: notMove);
  }

  @override
  void render(Canvas canvas, Offset offset) {
    if (this.isVisibleInCamera()) {
      canvas.save();
      canvas.translate(position.center.dx, position.center.dy);
      canvas.rotate(currentRadAngle == 0.0 ? 0.0 : currentRadAngle + (pi / 2));
      canvas.translate(-position.center.dx, -position.center.dy);
      _renderAnimation(canvas);
      canvas.restore();
    }
  }

  @override
  void update(double dt) {
    if (isVisibleInCamera()) {
      animation?.update(dt);
    }
    super.update(dt);
  }

  void idle() {
    this.animation = animIdle;
  }

  void _renderAnimation(Canvas canvas) {
    if (animation == null || position == null) return;
    if (animation.loaded) {
      animation.getSprite().renderRect(canvas, position);
    }
  }
}
