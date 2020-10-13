import 'dart:ui';

import 'package:bonfire/map/tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:little_engine/little_engine.dart';

import 'map_comp.dart';

class MapWorldComp extends MapComp {
  double lastCameraX = -1;
  double lastCameraY = -1;
  double lastZoom = -1;
  Size lastSizeScreen;
  Iterable<Tile> _tilesToRender = List();
  Iterable<Tile> _tilesCollisionsRendered = List();
  Iterable<Tile> _tilesCollisions = List();

  MapWorldComp(Iterable<Tile> tiles) : super(tiles) {
    _tilesCollisions = tiles.where((element) => element.containCollision());
  }

  @override
  void render(Canvas canvas, Offset offset) {
    for (final tile in _tilesToRender) {
      tile.render(canvas, offset);
    }
  }

  @override
  void update(double t) {
    if (lastCameraX != gameRef.gameCamera.position.x ||
        lastCameraY != gameRef.gameCamera.position.y ||
        lastZoom != gameRef.gameCamera.zoom) {
      lastCameraX = gameRef.gameCamera.position.x;
      lastCameraY = gameRef.gameCamera.position.y;
      lastZoom = gameRef.gameCamera.zoom;

      List<Tile> tilesRender = List();
      List<Tile> tilesCollision = List();
      for (final tile in tiles) {
        tile.gameRef ??= gameRef;
        if (tile.isVisibleInCamera()) {
          tilesRender.add(tile);
          if (tile.containCollision()) tilesCollision.add(tile);
        }
      }
      _tilesToRender = tilesRender;
      _tilesCollisionsRendered = tilesCollision;
    }
    for (final tile in _tilesToRender) {
      tile.update(t);
    }
  }

  @override
  Iterable<Tile> getRendered() {
    return _tilesToRender;
  }

  @override
  Iterable<Tile> getCollisionsRendered() {
    return _tilesCollisionsRendered;
  }

  @override
  Iterable<Tile> getCollisions() {
    return _tilesCollisions;
  }

  @override
  void resize(Size size) {
    verifyMaxTopAndLeft(size);
    super.resize(size);
  }

  void verifyMaxTopAndLeft(Size size) {
    if (lastSizeScreen == size) return;
    lastSizeScreen = size;

    lastCameraX = -1;
    lastCameraY = -1;
    lastZoom = -1;
    mapSize = getMapSize();
    mapStartPosition = getStartPosition();
  }

  @override
  void updateTiles(Iterable<Tile> map) {
    lastCameraX = -1;
    lastCameraY = -1;
    lastZoom = -1;
    lastSizeScreen = null;
    this.tiles = map;
    verifyMaxTopAndLeft(gameRef.size);
  }

  @override
  Size getMapSize() {
    double height = 0;
    double width = 0;

    this.tiles.forEach((tile) {
      if (tile.position.right > width) width = tile.position.right;
      if (tile.position.bottom > height) height = tile.position.bottom;
    });

    return Size(width, height);
  }

  LEPosition getStartPosition() {
    try {
      double x = this.tiles.first.position.left;
      double y = this.tiles.first.position.top;

      this.tiles.forEach((tile) {
        if (tile.position.left < x) x = tile.position.left;
        if (tile.position.top < y) y = tile.position.top;
      });

      return LEPosition(x, y);
    } catch (e) {
      return LEPosition.empty();
    }
  }
}
