import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/game_interface/interface_component.dart';
import 'package:flutter/material.dart';
import 'package:little_engine/little_engine.dart';

class TextInterfaceComponent extends InterfaceComponent {
  String text;
  TextConfig textConfig;
  TextInterfaceComponent({
    @required int id,
    @required LEPosition position,
    this.text = '',
    double width = 0,
    double height = 0,
    VoidCallback onTapComponent,
    TextConfig textConfig,
  }) : super(
          id: id,
          position: position,
          width: width,
          height: height,
          onTapComponent: onTapComponent,
        ) {
    this.textConfig = textConfig ?? TextConfig();
  }

  @override
  void render(Canvas canvas, Offset offset) {
    super.render(canvas, offset);
    textConfig.render(canvas, text, LEPosition(this.position.left, this.position.top));
  }
}
