import 'dart:ui';

import 'package:bonfire/enemy/extensions.dart';
import 'package:bonfire/enemy/simple/simple_enemy.dart';
import 'package:bonfire/lighting/lighting_config.dart';
import 'package:bonfire/objects/animated_object_once.dart';
import 'package:bonfire/objects/flying_attack_object.dart';
import 'package:bonfire/player/player.dart';
import 'package:bonfire/util/collision/collision.dart';
import 'package:bonfire/util/direction.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

extension SimpleEnemyExtensions on SimpleEnemy {
  void seeAndMoveToPlayer({
    Function(Player) closePlayer,
    double radiusVision = 32,
    double margin = 10,
  }) {
    if ((this.collisionOnlyVisibleScreen && !isVisibleInCamera()) || isDead || this.position == null) return;
    seePlayer(
      radiusVision: radiusVision,
      observed: (player) {
        double centerXPlayer = player.rectCollision.center.dx;
        double centerYPlayer = player.rectCollision.center.dy;

        double translateX = 0;
        double translateY = 0;
        double speed = this.speed * this.dtUpdate;

        translateX = this.rectCollision.center.dx > centerXPlayer ? (-1 * speed) : speed;
        translateX = _adjustTranslate(
          translateX,
          this.rectCollision.center.dx,
          centerXPlayer,
          speed,
        );
        translateY = this.rectCollision.center.dy > centerYPlayer ? (-1 * speed) : speed;
        translateY = _adjustTranslate(
          translateY,
          this.rectCollision.center.dy,
          centerYPlayer,
          speed,
        );

        if ((translateX < 0 && translateX > -0.1) || (translateX > 0 && translateX < 0.1)) {
          translateX = 0;
        }

        if ((translateY < 0 && translateY > -0.1) || (translateY > 0 && translateY < 0.1)) {
          translateY = 0;
        }

        Rect rectPlayerCollision = Rect.fromLTWH(
          player.rectCollision.left - margin,
          player.rectCollision.top - margin,
          player.rectCollision.width + (margin * 2),
          player.rectCollision.height + (margin * 2),
        );

        if (this.rectCollision.overlaps(rectPlayerCollision)) {
          if (closePlayer != null) closePlayer(player);
          this.idle();
          return;
        }

        if (translateX > 0 && translateY > 0) {
          this.customMoveBottomRight(translateX, translateY);
        } else if (translateX < 0 && translateY < 0) {
          this.customMoveTopLeft(translateX * -1, translateY * -1);
        } else if (translateX > 0 && translateY < 0) {
          this.customMoveTopRight(translateX, translateY * -1);
        } else if (translateX < 0 && translateY > 0) {
          this.customMoveBottomLeft(translateX * -1, translateY);
        } else {
          if (translateX > 0) {
            this.customMoveRight(translateX);
          } else if (translateX < 0) {
            customMoveLeft((translateX * -1));
          }
          if (translateY > 0) {
            customMoveBottom(translateY);
          } else if (translateY < 0) {
            customMoveTop((translateY * -1));
          }
        }
      },
      notObserved: () {
        this.idle();
      },
    );
  }

  void simpleAttackMelee({
    @required double damage,
    double heightArea = 32,
    double widthArea = 32,
    int id,
    int interval = 1000,
    bool withPush = false,
    double sizePush,
    Direction direction,
    LEFrameAnimation attackEffectRightAnim,
    LEFrameAnimation attackEffectBottomAnim,
    LEFrameAnimation attackEffectLeftAnim,
    LEFrameAnimation attackEffectTopAnim,
    VoidCallback execute,
  }) {
    if (!this.checkPassedInterval('attackMelee', interval, dtUpdate)) return;

    if (isDead || this.position == null) return;

    Rect positionAttack;
    LEFrameAnimation anim;

    Direction playerDirection;

    Player player = gameRef.player;

    if (direction == null) {
      double centerXPlayer = player.rectCollision.center.dx;
      double centerYPlayer = player.rectCollision.center.dy;

      double centerYEnemy = rectCollision.center.dy;
      double centerXEnemy = rectCollision.center.dx;

      double diffX = centerXEnemy - centerXPlayer;
      double diffY = centerYEnemy - centerYPlayer;

      double positiveDiffX = diffX > 0 ? diffX : diffX * -1;
      double positiveDiffY = diffY > 0 ? diffY : diffY * -1;
      if (positiveDiffX > positiveDiffY) {
        playerDirection = diffX > 0 ? Direction.left : Direction.right;
      } else {
        playerDirection = diffY > 0 ? Direction.top : Direction.bottom;
      }
    } else {
      playerDirection = direction;
    }

    double pushLeft = 0;
    double pushTop = 0;
    switch (playerDirection) {
      case Direction.top:
        positionAttack = Rect.fromLTWH(
          this.position.left + (this.width - widthArea) / 2,
          this.rectCollision.top - heightArea,
          widthArea,
          heightArea,
        );
        if (attackEffectTopAnim != null) anim = attackEffectTopAnim;
        pushTop = (sizePush ?? heightArea) * -1;
        break;
      case Direction.right:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.right,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (attackEffectRightAnim != null) anim = attackEffectRightAnim;
        pushLeft = (sizePush ?? widthArea);
        break;
      case Direction.bottom:
        positionAttack = Rect.fromLTWH(
          this.position.left + (this.width - widthArea) / 2,
          this.rectCollision.bottom,
          widthArea,
          heightArea,
        );
        if (attackEffectBottomAnim != null) anim = attackEffectBottomAnim;
        pushTop = (sizePush ?? heightArea);
        break;
      case Direction.left:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.left - widthArea,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (attackEffectLeftAnim != null) anim = attackEffectLeftAnim;
        pushLeft = (sizePush ?? widthArea) * -1;
        break;
      case Direction.topLeft:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.left - widthArea,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (attackEffectLeftAnim != null) anim = attackEffectLeftAnim;
        pushLeft = (sizePush ?? widthArea) * -1;
        break;
      case Direction.topRight:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.right,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (attackEffectRightAnim != null) anim = attackEffectRightAnim;
        pushLeft = (sizePush ?? widthArea);
        break;
      case Direction.bottomLeft:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.left - widthArea,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (attackEffectLeftAnim != null) anim = attackEffectLeftAnim;
        pushLeft = (sizePush ?? widthArea) * -1;
        break;
      case Direction.bottomRight:
        positionAttack = Rect.fromLTWH(
          this.rectCollision.right,
          this.position.top + (this.height - heightArea) / 2,
          widthArea,
          heightArea,
        );
        if (attackEffectRightAnim != null) anim = attackEffectRightAnim;
        pushLeft = (sizePush ?? widthArea);
        break;
    }

    if (anim != null) {
      gameRef.addComponentLater(AnimatedObjectOnce(animation: anim, position: positionAttack));
    }

    if (positionAttack.overlaps(player.rectCollision)) {
      player.receiveDamage(damage, id);

      if (withPush) {
        Rect rectAfterPush = player.position.translate(pushLeft, pushTop);
        if (!player.isCollision(displacement: rectAfterPush)) {
          player.position = rectAfterPush;
        }
      }
    }

    if (execute != null) execute();
  }

  void simpleAttackRange({
    @required LEFrameAnimation animationRight,
    @required LEFrameAnimation animationLeft,
    @required LEFrameAnimation animationTop,
    @required LEFrameAnimation animationBottom,
    @required LEFrameAnimation animationDestroy,
    @required double width,
    @required double height,
    int id,
    double speed = 150,
    double damage = 1,
    Direction direction,
    int interval = 1000,
    bool withCollision = true,
    bool collisionOnlyVisibleObjects = true,
    Collision collision,
    VoidCallback destroy,
    VoidCallback execute,
    LightingConfig lightingConfig,
  }) {
    if (!this.checkPassedInterval('attackRange', interval, dtUpdate)) return;

    Player player = this.gameRef.player;

    if (isDead) return;

    LEPosition startPosition;
    LEFrameAnimation attackRangeAnimation;

    Direction ballDirection;

    var diffX = this.rectCollision.center.dx - player.rectCollision.center.dx;
    var diffPositiveX = diffX < 0 ? diffX *= -1 : diffX;
    var diffY = this.rectCollision.center.dy - player.rectCollision.center.dy;
    var diffPositiveY = diffY < 0 ? diffY *= -1 : diffY;

    if (diffPositiveX > diffPositiveY) {
      if (player.rectCollision.center.dx > this.rectCollision.center.dx) {
        ballDirection = Direction.right;
      } else if (player.rectCollision.center.dx < this.rectCollision.center.dx) {
        ballDirection = Direction.left;
      }
    } else {
      if (player.rectCollision.center.dy > rectCollision.center.dy) {
        ballDirection = Direction.bottom;
      } else if (player.rectCollision.center.dy < rectCollision.center.dy) {
        ballDirection = Direction.top;
      }
    }

    Direction finalDirection = direction != null ? direction : ballDirection;

    switch (finalDirection) {
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

    this.lastDirection = finalDirection;
    if (finalDirection == Direction.right || finalDirection == Direction.left) {
      this.lastDirectionHorizontal = finalDirection;
    }

    gameRef.addComponentLater(
      FlyingAttackObject(
        id: id,
        direction: finalDirection,
        flyAnimation: attackRangeAnimation,
        destroyAnimation: animationDestroy,
        initPosition: startPosition,
        height: height,
        width: width,
        damage: damage,
        speed: speed,
        destroyedObject: destroy,
        withCollision: withCollision,
        collision: collision,
        lightingConfig: lightingConfig,
        collisionOnlyVisibleObjects: collisionOnlyVisibleObjects,
      ),
    );

    if (execute != null) execute();
  }

  void seeAndMoveToAttackRange({Function(Player) positioned, double radiusVision = 32, double minDistanceFromPlayer}) {
    if ((this.collisionOnlyVisibleScreen && !isVisibleInCamera()) || isDead || this.position == null) return;

    double distance = (minDistanceFromPlayer ?? radiusVision);

    seePlayer(
      radiusVision: radiusVision,
      observed: (player) {
        double centerXPlayer = player.rectCollision.center.dx;
        double centerYPlayer = player.rectCollision.center.dy;

        double translateX = 0;
        double translateY = 0;

        double speed = this.speed * this.dtUpdate;

        translateX = rectCollision.center.dx > centerXPlayer ? (-1 * speed) : speed;
        translateX = _adjustTranslate(
          translateX,
          rectCollision.center.dx,
          centerXPlayer,
          speed,
        );

        translateY = rectCollision.center.dy > centerYPlayer ? (-1 * speed) : speed;
        translateY = _adjustTranslate(
          translateY,
          rectCollision.center.dy,
          centerYPlayer,
          speed,
        );

        if ((translateX < 0 && translateX > -0.1) || (translateX > 0 && translateX < 0.1)) {
          translateX = 0;
        }

        if ((translateY < 0 && translateY > -0.1) || (translateY > 0 && translateY < 0.1)) {
          translateY = 0;
        }

        double translateXPositive = this.rectCollision.center.dx - player.rectCollision.center.dx;
        translateXPositive = translateXPositive >= 0 ? translateXPositive : translateXPositive * -1;

        double translateYPositive = this.rectCollision.center.dy - player.rectCollision.center.dy;
        translateYPositive = translateYPositive >= 0 ? translateYPositive : translateYPositive * -1;

        if (translateXPositive >= distance && translateXPositive > translateYPositive) {
          translateX = 0;
        } else if (translateXPositive > translateYPositive) {
          translateX = translateX * -1;
          positioned(player);
        }

        if (translateYPositive >= distance && translateXPositive < translateYPositive) {
          translateY = 0;
        } else if (translateXPositive < translateYPositive) {
          translateY = translateY * -1;
          positioned(player);
        }

        if (translateX == 0 && translateY == 0) {
          idle();
          positioned(player);
          return;
        }

        if (translateX > 0 && translateY > 0) {
          this.customMoveBottomRight(translateX, translateY);
        } else if (translateX < 0 && translateY < 0) {
          this.customMoveTopLeft(translateX * -1, translateY * -1);
        } else if (translateX > 0 && translateY < 0) {
          this.customMoveTopRight(translateX, translateY * -1);
        } else if (translateX < 0 && translateY > 0) {
          this.customMoveBottomLeft(translateX * -1, translateY);
        } else {
          if (translateX > 0) {
            this.customMoveRight(translateX);
          } else {
            customMoveLeft((translateX * -1));
          }
          if (translateY > 0) {
            customMoveBottom(translateY);
          } else {
            customMoveTop((translateY * -1));
          }
        }
      },
      notObserved: () {
        this.idle();
      },
    );
  }

  double _adjustTranslate(
    double translate,
    double centerEnemy,
    double centerPlayer,
    double speed,
  ) {
    double innerTranslate = translate;
    if (innerTranslate > 0) {
      double diffX = centerPlayer - centerEnemy;
      if (diffX < speed) {
        innerTranslate = diffX;
      }
    } else if (innerTranslate < 0) {
      double diffX = centerPlayer - centerEnemy;
      if (diffX > (speed * -1)) {
        innerTranslate = diffX;
      }
    }

    return innerTranslate;
  }
}
