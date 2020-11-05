import 'dart:math';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/util/collision/collision.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:bonfire/util/mixin/attacker.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart';

/// 玩家
///
/// 游戏组件+混合碰撞功能,攻击能力+实现遥感
class Player extends GameComponent with ObjectCollision, StitchAttacker, DebugRenders implements JoystickListener {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;

  /// Width of the Player.
  final double width;

  /// Height of the Player.
  final double height;

  /// World position that this Player must position yourself.
  final LEPosition initPosition;

  double life;
  double maxLife;

  bool _isDead = false;

  double dtUpdate = 0;
  bool isFocusCamera = true;

  @override
  get isAttackPlayer => true;

  Player({
    @required this.initPosition,
    this.width = 32,
    this.height = 32,
    this.life = 100,
    Collision collision,
  }) {
    position = Rect.fromLTWH(
      initPosition.x,
      initPosition.y,
      width,
      height,
    );

    this.collisions = [collision ?? Collision(width: width, height: height / 2)];
    maxLife = life;
  }

  @override
  void render(Canvas canvas, Offset offset) {
    super.render(canvas, offset);
    if (gameRef != null && gameRef.showCollisionArea && this.position != null) {
      drawCollision(canvas, position, gameRef.collisionAreaColor);
    }
  }

  @override
  void update(double dt) {
    dtUpdate = dt;
    isFocusCamera = (gameRef?.gameCamera?.target is Player);
    super.update(dt);
  }

  void moveTop(double speed) {
    double innerSpeed = speed * dtUpdate;

    Rect displacement = position.translate(0, (-innerSpeed));

    if (isCollision(displacement: displacement, onlyVisible: isFocusCamera)) return;

    position = displacement;
  }

  void moveRight(double speed) {
    double innerSpeed = speed * dtUpdate;

    Rect displacement = position.translate(innerSpeed, 0);

    if (isCollision(displacement: displacement, onlyVisible: isFocusCamera)) return;

    position = displacement;
  }

  void moveBottom(double speed) {
    double innerSpeed = speed * dtUpdate;

    Rect displacement = position.translate(0, innerSpeed);

    if (isCollision(displacement: displacement, onlyVisible: isFocusCamera)) return;

    position = displacement;
  }

  void moveLeft(double speed) {
    double innerSpeed = speed * dtUpdate;

    Rect displacement = position.translate(-innerSpeed, 0);

    if (isCollision(displacement: displacement, onlyVisible: isFocusCamera)) return;

    position = displacement;
  }

  void moveFromAngle(double speed, double angle) {
    double nextX = (speed * dtUpdate) * cos(angle);
    double nextY = (speed * dtUpdate) * sin(angle);
    Offset nextPoint = Offset(nextX, nextY);

    Offset diffBase = Offset(position.center.dx + nextPoint.dx, position.center.dy + nextPoint.dy) - position.center;

    Offset newDiffBase = diffBase;

    Rect newPosition = position.shift(newDiffBase);

    if (isCollision(displacement: newPosition, onlyVisible: isFocusCamera)) return;

    position = newPosition;
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    if (life > 0) {
      life -= damage;
      if (life <= 0) {
        die();
      }
    }
  }

  void die() {
    _isDead = true;
  }

  bool get isDead => _isDead;

  void addLife(double life) {
    this.life += life;
    if (this.life > maxLife) {
      this.life = maxLife;
    }
  }

  @override
  void joystickAction(JoystickActionEvent event) {}

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {}

  @override
  int get priority => PriorityLayer.PLAYER;

  @override
  Rect get attackScope => rectCollision;

  @override
  bool get debugMode => gameRef.debugMode;
  @override
  void renderDebugMode(Canvas canvas, Offset offset) {}
}
