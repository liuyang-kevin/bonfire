import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:example/map/dungeon_map.dart';
import 'package:little_engine/little_engine.dart';

class Spikes extends GameDecoration with Sensor {
  final LEPosition initPosition;
  Timer timer;

  bool isTick = false;

  Spikes(this.initPosition)
      : super.sprite(
          Sprite('itens/spikes.png'),
          initPosition: initPosition,
          width: DungeonMap.tileSize / 1.5,
          height: DungeonMap.tileSize / 1.5,
        );

  @override
  void onContact(ObjectCollision collision) {
    if (timer == null) {
      if (collision is StitchAttacker) {
        (collision as StitchAttacker).receiveDamage(10, 1);
        timer = Timer(Duration(milliseconds: 500), () {
          timer = null;
        });
      }
    }
  }
}
