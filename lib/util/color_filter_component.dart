import 'dart:ui';

import 'package:bonfire/base/rpg_game.dart';
import 'package:bonfire/util/game_color_filter.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:little_engine/little_engine.dart';

class ColorFilterComponent extends Component with StitchUpEngineRef<RPGGameEngine> {
  final GameColorFilter colorFilter;

  ColorFilterComponent(this.colorFilter);
  @override
  void render(Canvas canvas, Offset offset) {
    if (colorFilter?.enable == true) {
      canvas.save();
      canvas.drawColor(colorFilter?.color, colorFilter?.blendMode);
      canvas.restore();
    }
  }

  @override
  void update(double t) {
    colorFilter.gameRef = gameRef;
  }

  @override
  int get priority => PriorityLayer.LIGHTING + 1;
}
