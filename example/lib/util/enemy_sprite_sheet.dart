import 'package:bonfire/bonfire.dart';
import 'package:little_engine/little_engine.dart';

class EnemySpriteSheet {
  static LEFrameAnimation get idleLeft => LEFrameAnimation.sequenced(
        "enemy/goblin_idle_left.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get idleRight => LEFrameAnimation.sequenced(
        "enemy/goblin_idle.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get runRight => LEFrameAnimation.sequenced(
        "enemy/goblin_run_right.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get runLeft => LEFrameAnimation.sequenced(
        "enemy/goblin_run_left.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static SimpleDirectionAnimation get simpleDirectionAnimation => SimpleDirectionAnimation(
        idleLeft: idleLeft,
        idleRight: idleRight,
        runLeft: runLeft,
        runRight: runRight,
      );
}
