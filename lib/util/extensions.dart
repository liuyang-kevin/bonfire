import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:little_engine/little_engine.dart';

extension ImageExtension on Image {
  LEFrameAnimation getAnimation({
    @required double width,
    @required double height,
    @required double count,
    int startDx = 0,
    int startDy = 0,
    double stepTime = 0.1,
    bool loop = true,
  }) {
    List<Sprite> spriteList = List();
    for (int i = 0; i < count; i++) {
      spriteList.add(Sprite.fromImage(
        this,
        x: (startDx + (i * width)).toDouble(),
        y: startDy.toDouble(),
        width: width,
        height: height,
      ));
    }
    return LEFrameAnimation.spriteList(
      spriteList,
      loop: loop,
      stepTime: stepTime,
    );
  }

  Sprite getSprite({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) {
    return Sprite.fromImage(
      this,
      x: x,
      y: y,
      width: width,
      height: height,
    );
  }
}
