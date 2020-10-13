import 'package:bonfire/util/mixin/pointer_detector_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

class CustomWidgetBuilder {
  Widget build(LEGameEngine game) {
    return ClipRRect(
      child: Listener(
        onPointerDown:
            game is PointerDetector ? (PointerDownEvent d) => (game as PointerDetector).onPointerDown(d) : null,
        onPointerMove:
            game is PointerDetector ? (PointerMoveEvent d) => (game as PointerDetector).onPointerMove(d) : null,
        onPointerUp: game is PointerDetector ? (PointerUpEvent d) => (game as PointerDetector).onPointerUp(d) : null,
        onPointerCancel:
            game is PointerDetector ? (PointerCancelEvent d) => (game as PointerDetector).onPointerCancel(d) : null,
        child: Container(
          color: game.backgroundColor(),
          child: Directionality(child: LEStageWidget(game), textDirection: TextDirection.ltr),
        ),
      ),
    );
  }
}
