import 'package:little_engine/little_engine.dart';

class CommonSpriteSheet {
  static LEFrameAnimation get explosionAnimation => LEFrameAnimation.sequenced(
        'player/explosion_fire.png',
        6,
        textureWidth: 32,
        textureHeight: 32,
      );

  static LEFrameAnimation get emote => LEFrameAnimation.sequenced(
        'player/emote_exclamacao.png',
        8,
        textureWidth: 32,
        textureHeight: 32,
      );
  static LEFrameAnimation get smokeExplosion => LEFrameAnimation.sequenced(
        "smoke_explosin.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get whiteAttackEffectBottom => LEFrameAnimation.sequenced(
        'player/atack_effect_bottom.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get whiteAttackEffectLeft => LEFrameAnimation.sequenced(
        'player/atack_effect_left.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get whiteAttackEffectRight => LEFrameAnimation.sequenced(
        'player/atack_effect_right.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get whiteAttackEffectTop => LEFrameAnimation.sequenced(
        'player/atack_effect_top.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get blackAttackEffectBottom => LEFrameAnimation.sequenced(
        'enemy/atack_effect_bottom.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get blackAttackEffectLeft => LEFrameAnimation.sequenced(
        'enemy/atack_effect_left.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get blackAttackEffectRight => LEFrameAnimation.sequenced(
        'enemy/atack_effect_right.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get blackAttackEffectTop => LEFrameAnimation.sequenced(
        'enemy/atack_effect_top.png',
        6,
        textureWidth: 16,
        textureHeight: 16,
      );

  static LEFrameAnimation get fireBallRight => LEFrameAnimation.sequenced(
        'player/fireball_right.png',
        3,
        textureWidth: 23,
        textureHeight: 23,
      );

  static LEFrameAnimation get fireBallLeft => LEFrameAnimation.sequenced(
        'player/fireball_left.png',
        3,
        textureWidth: 23,
        textureHeight: 23,
      );

  static LEFrameAnimation get fireBallBottom => LEFrameAnimation.sequenced(
        'player/fireball_bottom.png',
        3,
        textureWidth: 23,
        textureHeight: 23,
      );

  static LEFrameAnimation get fireBallTop => LEFrameAnimation.sequenced(
        'player/fireball_top.png',
        3,
        textureWidth: 23,
        textureHeight: 23,
      );
}
