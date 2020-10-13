import 'dart:math';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/collision.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:bonfire/util/interval_tick.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart';

/// 敌人组件,基本跟玩家对象一致.
///
/// It is used to represent your enemies.
class Enemy extends GameComponent with ObjectCollision, StitchAttacker {
  /// Height of the Enemy.
  final double height;

  /// Width of the Enemy.
  final double width;

  /// Life of the Enemy.
  double life;

  /// Max life of the Enemy.
  double maxLife;

  bool _isDead = false;

  /// Map available to store times that can be used to control the frequency of any action.
  Map<String, IntervalTick> timers = Map();

  double dtUpdate = 0;

  bool collisionOnlyVisibleScreen = true;

  @override
  get isAttackEnemy => true;

  Enemy(
      {@required LEPosition initPosition,
      @required this.height,
      @required this.width,
      this.life = 10,
      Collision collision}) {
    maxLife = life;
    this.position = Rect.fromLTWH(
      initPosition.x,
      initPosition.y,
      width,
      height,
    );
    this.collisions = [collision ?? Collision(width: width, height: height / 2)];
  }

  bool get isDead => _isDead;

  @override
  void render(Canvas canvas, Offset offset) {
    super.render(canvas, offset);
    if (gameRef != null && gameRef.showCollisionArea) {
      drawCollision(canvas, position, gameRef.collisionAreaColor);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    dtUpdate = dt;
  }

  void moveTop(double speed) {
    var collision = isCollisionTranslate(
      position,
      0,
      (speed * -1),
      gameRef,
      onlyVisible: collisionOnlyVisibleScreen,
    );

    if (collision) return;

    position = position.translate(0, (speed * -1));
  }

  void moveBottom(double speed) {
    var collision = isCollisionTranslate(
      position,
      0,
      speed,
      gameRef,
      onlyVisible: collisionOnlyVisibleScreen,
    );
    if (collision) return;

    position = position.translate(0, speed);
  }

  void moveLeft(double speed) {
    var collision = isCollisionTranslate(
      position,
      (speed * -1),
      0,
      gameRef,
      onlyVisible: collisionOnlyVisibleScreen,
    );
    if (collision) return;

    position = position.translate((speed * -1), 0);
  }

  void moveRight(double speed) {
    var collision = isCollisionTranslate(
      position,
      speed,
      0,
      gameRef,
      onlyVisible: collisionOnlyVisibleScreen,
    );

    if (collision) return;

    position = position.translate(speed, 0);
  }

  void moveFromAngleDodgeObstacles(double speed, double angle, {Function notMove}) {
    double innerSpeed = (speed * dtUpdate);
    double nextX = innerSpeed * cos(angle);
    double nextY = innerSpeed * sin(angle);
    Offset nextPoint = Offset(nextX, nextY);

    Offset diffBase = Offset(position.center.dx + nextPoint.dx, position.center.dy + nextPoint.dy) - position.center;

    var collisionX = isCollisionTranslate(
      position,
      diffBase.dx,
      0,
      gameRef,
    );

    var collisionY = isCollisionTranslate(
      position,
      0,
      diffBase.dy,
      gameRef,
    );
    Offset newDiffBase = diffBase;
    if (collisionX) {
      newDiffBase = Offset(0, newDiffBase.dy);
    }
    if (collisionY) {
      newDiffBase = Offset(newDiffBase.dx, 0);
    }

    if (collisionX && !collisionY && newDiffBase.dy != 0) {
      var collisionY = isCollisionTranslate(
        position,
        0,
        innerSpeed,
        gameRef,
      );
      if (!collisionY) newDiffBase = Offset(0, innerSpeed);
    }

    if (collisionY && !collisionX && newDiffBase.dx != 0) {
      var collisionX = isCollisionTranslate(
        position,
        innerSpeed,
        0,
        gameRef,
      );
      if (!collisionX) newDiffBase = Offset(innerSpeed, 0);
    }

    if (newDiffBase == Offset.zero && notMove != null) {
      notMove();
    }
    this.position = position.shift(newDiffBase);
  }

  void moveFromAngle(double speed, double angle) {
    double innerSpeed = (speed * dtUpdate);
    double nextX = innerSpeed * cos(angle);
    double nextY = innerSpeed * sin(angle);
    Offset nextPoint = Offset(nextX, nextY);

    Offset diffBase = Offset(position.center.dx + nextPoint.dx, position.center.dy + nextPoint.dy) - position.center;
    this.position = position.shift(diffBase);
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

  void addLife(double life) {
    this.life += life;
    if (this.life > maxLife) {
      this.life = maxLife;
    }
  }

  void die() {
    _isDead = true;
  }

  bool checkPassedInterval(String name, int intervalInMilli, double dt) {
    if (this.timers[name] == null || (this.timers[name] != null && this.timers[name].interval != intervalInMilli)) {
      this.timers[name] = IntervalTick(intervalInMilli);
      return true;
    } else {
      return this.timers[name].update(dt);
    }
  }

  Rect get rectCollision => getRectCollision(position);

  @override
  int get priority => PriorityLayer.ENEMY;

  @override
  Rect get attackScope => rectCollision;
}
