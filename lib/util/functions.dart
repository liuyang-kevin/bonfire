import 'dart:math';
import 'dart:ui';

import 'package:little_engine/little_engine.dart';

void renderSpriteByRadAngle(Canvas canvas, double radAngle, Rect rect, Sprite sprite) {
  canvas.save();
  canvas.translate(rect.center.dx, rect.center.dy);
  canvas.rotate(radAngle == 0.0 ? 0.0 : radAngle + (pi / 2));
  canvas.translate(-rect.center.dx, -rect.center.dy);
  sprite.renderRect(canvas, rect);
  canvas.restore();
}
