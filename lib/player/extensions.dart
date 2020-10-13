import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/enemy/enemy.dart';
import 'package:bonfire/lighting/lighting_config.dart';
import 'package:bonfire/objects/animated_object_once.dart';
import 'package:bonfire/objects/flying_attack_angle_object.dart';
import 'package:bonfire/objects/flying_attack_object.dart';
import 'package:bonfire/player/player.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:bonfire/util/text_damage_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

/// 扩展 玩家类型
extension PlayerExtensions on Player {
  /// 攻击后,显示伤害数值
  void showDamage(
    double damage, {
    TextConfig config,
    double initVelocityTop = -5,
    double gravity = 0.5,
    double maxDownSize = 20,
    bool onlyUp = false,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
  }) {
    // 对引擎添加一个伤害文本comp,
    gameRef.addComponentLater(
      TextDamageComponent(
        damage.toInt().toString(),
        LEPosition(position.center.dx, position.top),
        config: config ?? TextConfig(fontSize: 14, color: Colors.red),
        initVelocityTop: initVelocityTop,
        gravity: gravity,
        direction: direction,
        onlyUp: onlyUp,
        maxDownSize: maxDownSize,
      ),
    );
  }

  /// 观测敌人
  ///
  /// * observed 回调:观测到的敌人
  /// * notObserved 回调:没有敌人被观测到
  /// * [radiusVision] 视野半径
  void seeEnemy({
    Function(List<Enemy>) observed,
    Function() notObserved,
    double radiusVision = 32,
  }) {
    if (isDead || this.position == null) return;

    var enemiesInLife = this.gameRef.visibleEnemies();
    if (enemiesInLife.isEmpty) {
      if (notObserved != null) notObserved();
      return;
    }

    //region 视野区域,半径翻倍
    double visionWidth = radiusVision * 2;
    double visionHeight = radiusVision * 2;

    Rect fieldOfVision = Rect.fromLTWH(
        this.position.center.dx - radiusVision, this.position.center.dy - radiusVision, visionWidth, visionHeight);
    //endregion

    // 筛选敌人
    List<Enemy> enemiesObserved =
        enemiesInLife.where((enemy) => enemy.position != null && fieldOfVision.overlaps(enemy.position)).toList();

    if (enemiesObserved.isNotEmpty) {
      if (observed != null) observed(enemiesObserved);
    } else {
      if (notObserved != null) notObserved();
    }
  }

  ///
  void simpleAttackRangeByAngle({
    @required LEFrameAnimation animationTop,
    @required double width,
    @required double height,
    @required double radAngleDirection,
    LEFrameAnimation animationDestroy,
    dynamic id,
    double speed = 150,
    double damage = 1,
    bool withCollision = true,
    bool collisionOnlyVisibleObjects = true,
    VoidCallback destroy,
    Collision collision,
    LightingConfig lightingConfig,
  }) {
    if (isDead) return;

    double angle = radAngleDirection;
    double nextX = this.height * cos(angle);
    double nextY = this.height * sin(angle);
    Offset nextPoint = Offset(nextX, nextY);

    Offset diffBase =
        Offset(this.position.center.dx + nextPoint.dx, this.position.center.dy + nextPoint.dy) - this.position.center;

    Rect position = this.position.shift(diffBase);
    gameRef.addComponentLater(FlyingAttackAngleObject(
      id: id,
      initPosition: LEPosition(position.left, position.top),
      radAngle: angle,
      width: width,
      height: height,
      damage: damage,
      speed: speed,
      damageInPlayer: false,
      collision: collision,
      withCollision: withCollision,
      destroyedObject: destroy,
      flyAnimation: animationTop,
      destroyAnimation: animationDestroy,
      lightingConfig: lightingConfig,
      collisionOnlyVisibleObjects: collisionOnlyVisibleObjects,
    ));
  }

  ///
  void simpleAttackRangeByDirection({
    @required LEFrameAnimation animationRight,
    @required LEFrameAnimation animationLeft,
    @required LEFrameAnimation animationTop,
    @required LEFrameAnimation animationBottom,
    LEFrameAnimation animationDestroy,
    @required double width,
    @required double height,
    @required Direction direction,
    dynamic id,
    double speed = 150,
    double damage = 1,
    bool withCollision = true,
    bool collisionOnlyVisibleObjects = true,
    VoidCallback destroy,
    Collision collision,
    LightingConfig lightingConfig,
  }) {
    if (isDead) return;

    LEPosition startPosition;
    LEFrameAnimation attackRangeAnimation;

    Direction attackDirection = direction;

    switch (attackDirection) {
      case Direction.left:
        if (animationLeft != null) attackRangeAnimation = animationLeft;
        startPosition = LEPosition(
          this.rectCollision.left - width,
          (this.rectCollision.top + (this.rectCollision.height - height) / 2),
        );
        break;
      case Direction.right:
        if (animationRight != null) attackRangeAnimation = animationRight;
        startPosition = LEPosition(
          this.rectCollision.right,
          (this.rectCollision.top + (this.rectCollision.height - height) / 2),
        );
        break;
      case Direction.top:
        if (animationTop != null) attackRangeAnimation = animationTop;
        startPosition = LEPosition(
          (this.rectCollision.left + (this.rectCollision.width - width) / 2),
          this.rectCollision.top - height,
        );
        break;
      case Direction.bottom:
        if (animationBottom != null) attackRangeAnimation = animationBottom;
        startPosition = LEPosition(
          (this.rectCollision.left + (this.rectCollision.width - width) / 2),
          this.rectCollision.bottom,
        );
        break;
      case Direction.topLeft:
        if (animationLeft != null) attackRangeAnimation = animationLeft;
        startPosition = LEPosition(
          this.rectCollision.left - width,
          (this.rectCollision.top + (this.rectCollision.height - height) / 2),
        );
        break;
      case Direction.topRight:
        if (animationRight != null) attackRangeAnimation = animationRight;
        startPosition = LEPosition(
          this.rectCollision.right,
          (this.rectCollision.top + (this.rectCollision.height - height) / 2),
        );
        break;
      case Direction.bottomLeft:
        if (animationLeft != null) attackRangeAnimation = animationLeft;
        startPosition = LEPosition(
          this.rectCollision.left - width,
          (this.rectCollision.top + (this.rectCollision.height - height) / 2),
        );
        break;
      case Direction.bottomRight:
        if (animationRight != null) attackRangeAnimation = animationRight;
        startPosition = LEPosition(
          this.rectCollision.right,
          (this.rectCollision.top + (this.rectCollision.height - height) / 2),
        );
        break;
    }

    gameRef.addComponentLater(
      FlyingAttackObject(
        id: id,
        direction: attackDirection,
        flyAnimation: attackRangeAnimation,
        destroyAnimation: animationDestroy,
        initPosition: startPosition,
        height: height,
        width: width,
        damage: damage,
        speed: speed,
        damageInPlayer: false,
        destroyedObject: destroy,
        withCollision: withCollision,
        collision: collision,
        lightingConfig: lightingConfig,
        collisionOnlyVisibleObjects: collisionOnlyVisibleObjects,
      ),
    );
  }

  /// 固定方向近战
  void simpleAttackMeleeByDirection({
    LEFrameAnimation animationRight,
    LEFrameAnimation animationBottom,
    LEFrameAnimation animationLeft,
    LEFrameAnimation animationTop,
    @required double damage,
    @required Direction direction,
    dynamic id,
    double heightArea = 32,
    double widthArea = 32,
    bool withPush = true,
    double sizePush,
  }) {
    if (isDead) return;

    Rect positionAttack;
    LEFrameAnimation anim;
    double pushLeft = 0;
    double pushTop = 0;
    Direction attackDirection = direction;
    switch (attackDirection) {
      case Direction.top:
        positionAttack = Rect.fromLTWH(
          this.position.left + (this.width - widthArea) / 2,
          rectCollision.top - heightArea,
          widthArea,
          heightArea,
        );
        if (animationTop != null) anim = animationTop;
        pushTop = (sizePush ?? heightArea) * -1;
        break;
      case Direction.right:
        positionAttack = Rect.fromLTWH(
          rectCollision.right,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (animationRight != null) anim = animationRight;
        pushLeft = (sizePush ?? widthArea);
        break;
      case Direction.bottom:
        positionAttack = Rect.fromLTWH(
          this.position.left + (this.width - widthArea) / 2,
          this.rectCollision.bottom,
          widthArea,
          heightArea,
        );
        if (animationBottom != null) anim = animationBottom;
        pushTop = (sizePush ?? heightArea);
        break;
      case Direction.left:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.left - widthArea,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (animationLeft != null) anim = animationLeft;
        pushLeft = (sizePush ?? widthArea) * -1;
        break;
      case Direction.topLeft:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.left - widthArea,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (animationLeft != null) anim = animationLeft;
        pushLeft = (sizePush ?? widthArea) * -1;
        break;
      case Direction.topRight:
        positionAttack = Rect.fromLTWH(
          rectCollision.right,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (animationRight != null) anim = animationRight;
        pushLeft = (sizePush ?? widthArea);
        break;
      case Direction.bottomLeft:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.left - widthArea,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (animationLeft != null) anim = animationLeft;
        pushLeft = (sizePush ?? widthArea) * -1;
        break;
      case Direction.bottomRight:
        positionAttack = Rect.fromLTWH(
          rectCollision.right,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (animationRight != null) anim = animationRight;
        pushLeft = (sizePush ?? widthArea);
        break;
    }

    if (anim != null) {
      gameRef.addComponentLater(AnimatedObjectOnce(
        animation: anim,
        position: positionAttack,
      ));
    }

    gameRef.attackers().where((a) => !a.isAttackPlayer && a.attackScope.overlaps(positionAttack)).forEach(
      (enemy) {
        enemy.receiveDamage(damage, id);
        Rect rectAfterPush = enemy.position.translate(pushLeft, pushTop);
        if (withPush &&
            (enemy is ObjectCollision && !(enemy as ObjectCollision).isCollision(displacement: rectAfterPush))) {
          enemy.translate(pushLeft, pushTop);
        }
      },
    );
  }

  /// 带角度近战
  ///
  /// * [withPush] 带击退效果, 计算伤害后,计算碰撞,重设敌人位置
  void simpleAttackMeleeByAngle({
    @required LEFrameAnimation animationTop,
    @required double damage,
    @required double radAngleDirection,
    dynamic id,
    double heightArea = 32,
    double widthArea = 32,
    bool withPush = true,
  }) {
    if (isDead) return;

    double angle = radAngleDirection;

    double nextX = this.height * cos(angle);
    double nextY = this.height * sin(angle);
    Offset nextPoint = Offset(nextX, nextY);

    Offset diffBase =
        Offset(this.position.center.dx + nextPoint.dx, this.position.center.dy + nextPoint.dy) - this.position.center;

    Rect positionAttack = this.position.shift(diffBase);

    // 添加一次性攻击动画
    gameRef.addComponentLater(AnimatedObjectOnce(
      animation: animationTop,
      position: positionAttack,
      rotateRadAngle: angle,
    ));

    // 从存在的攻击人里筛选敌人,计算结果,  [withPush] 带击退效果, 计算伤害后,计算碰撞,重设敌人位置
    gameRef.attackers().where((a) => !a.isAttackPlayer && a.attackScope.overlaps(positionAttack)).forEach((enemy) {
      enemy.receiveDamage(damage, id);
      Rect rectAfterPush = position.translate(diffBase.dx, diffBase.dy);
      if (withPush &&
          (enemy is ObjectCollision && !(enemy as ObjectCollision).isCollision(displacement: rectAfterPush))) {
        translate(diffBase.dx, diffBase.dy);
      }
    });
  }
}
