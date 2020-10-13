import 'dart:ui';

import 'package:bonfire/base/rpg_game.dart';
import 'package:bonfire/map/tile.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:little_engine/little_engine.dart';

abstract class MapComp extends Component with StitchUpEngineRef<RPGGameEngine> {
  Iterable<Tile> tiles;
  Size mapSize;
  LEPosition mapStartPosition;

  MapComp(this.tiles);

  Iterable<Tile> getRendered();

  Iterable<Tile> getCollisionsRendered();
  Iterable<Tile> getCollisions();

  void updateTiles(Iterable<Tile> map);

  Size getMapSize();

  @override
  int get priority => PriorityLayer.MAP;
}
