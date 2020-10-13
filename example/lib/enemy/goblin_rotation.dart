import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:example/map/dungeon_map.dart';
import 'package:little_engine/little_engine.dart';

class GoblinRotation extends RotationEnemy {
  GoblinRotation(LEPosition initPosition)
      : super(
          animIdle: LEFrameAnimation.sequenced(
            "enemy/goblin_idle.png",
            6,
            textureWidth: 16,
            textureHeight: 16,
          ),
          animRun: LEFrameAnimation.sequenced(
            "enemy/goblin_run_left.png",
            6,
            textureWidth: 16,
            textureHeight: 16,
          ),
          initPosition: initPosition,
          width: 25,
          height: 25,
        );

  @override
  void render(Canvas canvas, Offset offset) {
    super.render(canvas, offset);
    this.drawDefaultLifeBar(canvas);
  }

  @override
  void update(double dt) {
    this.seeAndMoveToAttackRange(
        positioned: (player) {
          this.simpleAttackRange(
              animationTop: LEFrameAnimation.sequenced(
                'player/fireball_top.png',
                3,
                textureWidth: 23,
                textureHeight: 23,
              ),
              animationDestroy: LEFrameAnimation.sequenced(
                'player/explosion_fire.png',
                6,
                textureWidth: 32,
                textureHeight: 32,
              ),
              width: 25,
              height: 25,
              damage: 10,
              speed: speed * 1.5,
              collision: Collision(height: 15, width: 15));
        },
        radiusVision: DungeonMap.tileSize * 4,
        minDistanceCellsFromPlayer: 3);
    super.update(dt);
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    this.showDamage(damage);
    super.receiveDamage(damage, from);
  }

  @override
  void die() {
    gameRef.addComponentLater(
      AnimatedObjectOnce(
          animation: LEFrameAnimation.sequenced(
            "smoke_explosin.png",
            6,
            textureWidth: 16,
            textureHeight: 16,
          ),
          position: position),
    );
    remove();
    super.die();
  }
}
