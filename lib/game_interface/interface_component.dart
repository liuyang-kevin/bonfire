import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/util/gestures/tap_gesture.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

class InterfaceComponent extends GameComponent with TapGesture {
  final int id;
  final Sprite sprite;
  final Sprite spriteSelected;
  final VoidCallback onTapComponent;
  final double width;
  final double height;
  Sprite spriteToRender;

  @override
  bool get isHud => true;

  InterfaceComponent({
    @required this.id,
    @required LEPosition position,
    @required this.width,
    @required this.height,
    this.sprite,
    this.spriteSelected,
    this.onTapComponent,
  }) {
    this.position = Rect.fromLTWH(position.x, position.y, width, height);
    spriteToRender = sprite;
  }

  @override
  void render(Canvas canvas, Offset offset) {
    if (spriteToRender != null && this.position != null && spriteToRender.loaded)
      spriteToRender.renderRect(canvas, this.position);
  }

  @override
  void onTapDown(int pointer, Offset position) {
    if (spriteSelected != null) spriteToRender = spriteSelected;
    super.onTapDown(pointer, position);
  }

  @override
  void onTapCancel() {
    spriteToRender = sprite;
    super.onTapCancel();
  }

  @override
  void onTap() {
    if (onTapComponent != null) onTapComponent();
    spriteToRender = sprite;
  }

  @override
  void update(double t) {}
}
