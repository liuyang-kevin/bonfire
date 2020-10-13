import 'package:bonfire/lighting/lighting_config.dart';
import 'package:bonfire/player/extensions.dart';
import 'package:bonfire/player/rotation/rotation_player.dart';
import 'package:bonfire/util/collision/collision.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

/// 扩展可旋转玩家对象, 近战,远程攻击动画
extension RotationPlayerExtensions on RotationPlayer {
  void simpleAttackRange({
    @required LEFrameAnimation animationTop,
    @required double width,
    @required double height,
    LEFrameAnimation animationDestroy,
    int id,
    double speed = 150,
    double damage = 1,
    double radAngleDirection,
    bool withCollision = true,
    VoidCallback destroy,
    Collision collision,
    LightingConfig lightingConfig,
  }) {
    if (this.currentRadAngle == 0) return;

    double angle = radAngleDirection ?? this.currentRadAngle;

    this.simpleAttackRangeByAngle(
      radAngleDirection: angle,
      animationTop: animationTop,
      animationDestroy: animationDestroy,
      width: width,
      height: height,
      id: id,
      speed: speed,
      damage: damage,
      withCollision: withCollision,
      destroy: destroy,
      collision: collision,
      lightingConfig: lightingConfig,
    );
  }

  void simpleAttackMelee({
    @required LEFrameAnimation animationTop,
    @required double damage,
    int id,
    double radAngleDirection,
    double heightArea = 32,
    double widthArea = 32,
    bool withPush = true,
  }) {
    double angle = radAngleDirection ?? this.currentRadAngle;
    this.simpleAttackMeleeByAngle(
      radAngleDirection: angle,
      animationTop: animationTop,
      damage: damage,
      id: id,
      heightArea: heightArea,
      widthArea: widthArea,
      withPush: withPush,
    );
  }
}
