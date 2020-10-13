import 'package:bonfire/lighting/lighting_config.dart';
import 'package:bonfire/player/extensions.dart';
import 'package:bonfire/player/simple/simple_player.dart';
import 'package:bonfire/util/collision/collision.dart';
import 'package:bonfire/util/direction.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

/// 对SimplePlayer扩展, 扩展近战\远程攻击动画
extension SimplePlayerExtensions on SimplePlayer {
  void simpleAttackMelee({
    LEFrameAnimation animationRight,
    LEFrameAnimation animationBottom,
    LEFrameAnimation animationLeft,
    LEFrameAnimation animationTop,
    @required double damage,
    dynamic id,
    Direction direction,
    double heightArea = 32,
    double widthArea = 32,
    bool withPush = true,
  }) {
    Direction attackDirection = direction ?? this.lastDirection;
    this.simpleAttackMeleeByDirection(
      direction: attackDirection,
      animationRight: animationRight,
      animationBottom: animationBottom,
      animationLeft: animationLeft,
      animationTop: animationTop,
      damage: damage,
      id: id,
      heightArea: heightArea,
      widthArea: widthArea,
      withPush: withPush,
    );
  }

  void simpleAttackRange({
    @required LEFrameAnimation animationRight,
    @required LEFrameAnimation animationLeft,
    @required LEFrameAnimation animationTop,
    @required LEFrameAnimation animationBottom,
    LEFrameAnimation animationDestroy,
    @required double width,
    @required double height,
    dynamic id,
    double speed = 150,
    double damage = 1,
    Direction direction,
    bool withCollision = true,
    VoidCallback destroy,
    Collision collision,
    LightingConfig lightingConfig,
  }) {
    Direction attackDirection = direction ?? this.lastDirection;
    this.simpleAttackRangeByDirection(
      direction: attackDirection,
      animationRight: animationRight,
      animationLeft: animationLeft,
      animationTop: animationTop,
      animationBottom: animationBottom,
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
}
