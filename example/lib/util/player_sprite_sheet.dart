import 'package:bonfire/bonfire.dart';
import 'package:little_engine/little_engine.dart';

class PlayerSpriteSheet {
  static LEFrameAnimation get idleLeft => LEFrameAnimation.sequenced(
        "player/knight_idle_left.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get idleRight => LEFrameAnimation.sequenced(
        "player/knight_idle.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get runRight => LEFrameAnimation.sequenced(
        "player/knight_run.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get runLeft => LEFrameAnimation.sequenced(
        "player/knight_run_left.png",
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
