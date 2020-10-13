import 'dart:math';

import 'package:bonfire/base/rpg_game.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:little_engine/little_engine.dart';

enum DirectionTextDamage { LEFT, RIGHT, RANDOM, NONE }

/// 攻击数据显示
///
/// 攻击数值抖动,由[_position]位置完成
class TextDamageComponent extends TextComp with StitchUpEngineRef<RPGGameEngine> {
  final String text;
  final TextConfig config;
  final LEPosition initPosition;
  final DirectionTextDamage direction;
  final double maxDownSize;
  bool destroyed = false;
  LEPosition _position;
  double _initialY;
  double _velocity;
  final double gravity;
  double _moveAxisX = 0;
  final bool onlyUp;

  TextDamageComponent(
    this.text,
    this.initPosition, {
    this.onlyUp = false,
    this.config,
    double initVelocityTop = -4,
    this.maxDownSize = 20,
    this.gravity = 0.5,
    this.direction = DirectionTextDamage.RANDOM,
  }) : super(text, config: (config ?? TextConfig(fontSize: 10))) {
    _position = initPosition;
    _initialY = _position.y;
    _velocity = initVelocityTop;
    switch (direction) {
      case DirectionTextDamage.LEFT:
        _moveAxisX = 1;
        break;
      case DirectionTextDamage.RIGHT:
        _moveAxisX = -1;
        break;
      case DirectionTextDamage.RANDOM:
        _moveAxisX = Random().nextInt(100) % 2 == 0 ? -1 : 1;
        break;
      case DirectionTextDamage.NONE:
        break;
    }
    position = _position;
  }

  @override
  bool willDestroy() => destroyed;

  @override
  void update(double t) {
    position = _position;
    _position.y += _velocity;
    _position.x += _moveAxisX;
    _velocity += gravity;

    if (onlyUp && _velocity >= 0) {
      remove();
    }
    if (_position.y > _initialY + maxDownSize) {
      remove();
    }

    super.update(t);
  }

  void remove() {
    destroyed = true;
  }

  @override
  int get priority => PriorityLayer.OBJECTS;
}
