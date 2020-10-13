import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/objects/animated_object.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

export 'package:bonfire/decoration/extensions.dart';

/// 游戏装饰物, 可以是血条等UI, 也可是操作对象
///
/// [additionalPriority] 为 0 ,为装饰器[PriorityLayer.DECORATION]优先级别
/// [additionalPriority] !0 ,为对象优先级[PriorityLayer.OBJECTS]+[additionalPriority]
/// 该组件表示您想要添加到场景中的任何内容，可以是NPC中间的一个简单“桶”，可以用来与播放器进行交互。
/// This component represents anything you want to add to the scene, it can be
/// a simple "barrel" halfway to an NPC that you can use to interact with your
/// player.
///
/// You can use ImageSprite or Animation[LEFrameAnimation]
class GameDecoration extends AnimatedObject with ObjectCollision {
  /// Height of the Decoration.
  final double height;

  /// Width of the Decoration.
  final double width;

  /// Use to define if this decoration should be drawing on the player.
  final bool frontFromPlayer;

  /// World position that this decoration must position yourself.
  final LEPosition initPosition;

  Sprite sprite;

  int additionalPriority = 0;

  GameDecoration({
    this.sprite,
    @required this.initPosition,
    @required this.height,
    @required this.width,
    this.frontFromPlayer = false,
    LEFrameAnimation animation,
    Collision collision,
  }) {
    if (frontFromPlayer) additionalPriority = 1;
    this.animation = animation;
    this.position = generateRectWithBleedingPixel(
      initPosition,
      width,
      height,
    );
    if (collision != null) this.collisions = [collision];
  }

  GameDecoration.sprite(
    this.sprite, {
    @required this.initPosition,
    @required this.height,
    @required this.width,
    this.frontFromPlayer = false,
    Collision collision,
  }) {
    if (frontFromPlayer) additionalPriority = 1;
    this.position = generateRectWithBleedingPixel(
      initPosition,
      width,
      height,
    );
    if (collision != null) this.collisions = [collision];
  }

  GameDecoration.animation(
    LEFrameAnimation animation, {
    @required this.initPosition,
    @required this.height,
    @required this.width,
    this.frontFromPlayer = false,
    Collision collision,
  }) {
    if (frontFromPlayer) additionalPriority = 1;
    this.animation = animation;
    this.position = generateRectWithBleedingPixel(
      initPosition,
      width,
      height,
    );
    if (collision != null) this.collisions = [collision];
  }

  GameDecoration.spriteMultiCollision(
    this.sprite, {
    @required this.initPosition,
    @required this.height,
    @required this.width,
    this.frontFromPlayer = false,
    List<Collision> collisions,
  }) {
    if (frontFromPlayer) additionalPriority = 1;
    this.position = generateRectWithBleedingPixel(
      initPosition,
      width,
      height,
    );
    this.collisions = collisions;
  }

  GameDecoration.animationMultiCollision(
    LEFrameAnimation animation, {
    @required this.initPosition,
    @required this.height,
    @required this.width,
    this.frontFromPlayer = false,
    List<Collision> collisions,
  }) {
    if (frontFromPlayer) additionalPriority = 1;
    this.animation = animation;
    this.position = generateRectWithBleedingPixel(
      initPosition,
      width,
      height,
    );
    this.collisions = collisions;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas, Offset offset) {
    if (sprite != null && sprite.loaded) sprite.renderRect(canvas, position);

    super.render(canvas, offset);

    if (gameRef != null && gameRef.showCollisionArea) {
      drawCollision(canvas, position, gameRef.collisionAreaColor);
    }
  }

  Rect generateRectWithBleedingPixel(LEPosition position, double width, double height) {
    double bleendingPixel = (width > height ? width : height) * 0.03;
    if (bleendingPixel > 2) {
      bleendingPixel = 2;
    }
    return Rect.fromLTWH(
      position.x - (position.x % 2 == 0 ? (bleendingPixel / 2) : 0),
      position.y - (position.y % 2 == 0 ? (bleendingPixel / 2) : 0),
      width + (position.x % 2 == 0 ? bleendingPixel : 0),
      height + (position.y % 2 == 0 ? bleendingPixel : 0),
    );
  }

  @override
  int get priority {
    if (additionalPriority == 0) {
      return PriorityLayer.DECORATION;
    } else {
      return PriorityLayer.OBJECTS + additionalPriority;
    }
  }
}
