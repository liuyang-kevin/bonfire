import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/game_interface/interface_component.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

class GameInterface extends GameComponent with TapGesture {
  List<InterfaceComponent> _components = List();
  final textConfigGreen = TextConfig(color: Colors.green, fontSize: 14);
  final textConfigYellow = TextConfig(color: Colors.yellow, fontSize: 14);
  final textConfigRed = TextConfig(color: Colors.red, fontSize: 14);

  @override
  bool get isHud => true;

  @override
  int get priority => PriorityLayer.GAME_INTERFACE;

  @override
  void render(Canvas c, Offset offset) {
    _components.forEach((i) => i.render(c, offset));
    _drawFPS(c);
  }

  @override
  void update(double t) {
    _components.forEach((i) {
      i.gameRef = gameRef;
      i.update(t);
    });
  }

  void add(InterfaceComponent component) {
    removeById(component.id);
    _components.add(component);
  }

  void removeById(int id) {
    if (_components.isEmpty) return;
    _components.removeWhere((i) => i.id == id);
  }

  @override
  void handlerPointerDown(int pointer, Offset position) {
    _components.forEach((i) => i.handlerPointerDown(pointer, position));
    super.handlerPointerDown(pointer, position);
  }

  @override
  void handlerPointerUp(int pointer, Offset position) {
    _components.forEach((i) => i.handlerPointerUp(pointer, position));
    super.handlerPointerUp(pointer, position);
  }

  void _drawFPS(Canvas c) {
    if (gameRef?.showFPS == true && gameRef?.size != null) {
      double fps = gameRef.fps(100);
      getTextConfigFps(fps).render(c, 'FPS: ${fps.toStringAsFixed(2)}', LEPosition(gameRef.size.width - 100, 20));
    }
  }

  TextConfig getTextConfigFps(double fps) {
    if (fps >= 58) {
      return textConfigGreen;
    }

    if (fps >= 48) {
      return textConfigYellow;
    }

    return textConfigRed;
  }

  @override
  void onTap() {}
}
