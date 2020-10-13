import 'dart:ui';

import 'package:bonfire/base/rpg_game.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:bonfire/util/gestures/drag_gesture.dart';
import 'package:bonfire/util/gestures/tap_gesture.dart';
import 'package:little_engine/little_engine.dart';

/// 游戏组件,可能是编辑时使用
abstract class GameComponent extends Component with StitchUpEngineRef<RPGGameEngine> {
  /// Position used to draw on the screen
  Rect position;

  /// Variable used to control whether the component has been destroyed.
  bool _isDestroyed = false;

  void handlerPointerDown(int pointer, Offset position) {
    if (this.position == null || gameRef == null) return;

    if (this is TapGesture) {
      (this as TapGesture).onTapDown(pointer, position);
    }
    if (this is DragGesture) {
      (this as DragGesture).startDrag(pointer, position);
    }
  }

  void handlerPointerMove(int pointer, Offset position) {
    if (this is DragGesture) {
      (this as DragGesture).moveDrag(pointer, position);
    }
  }

  void handlerPointerUp(int pointer, Offset position) {
    if (this.position == null) return;
    if (this is TapGesture) {
      (this as TapGesture).onTapUp(pointer, position);
    }

    if (this is DragGesture) {
      (this as DragGesture).endDrag(pointer);
    }
  }

  @override
  void render(Canvas c, Offset offset) {}

  @override
  void update(double t) {
    position ??= Rect.zero;
  }

  @override
  bool willDestroy() => _isDestroyed;

  /// This method destroy of the component
  void remove() {
    _isDestroyed = true;
  }

  bool isVisibleInCamera() {
    if (gameRef == null || gameRef?.size == null || position == null || willDestroy()) return false;

    return gameRef.gameCamera.isComponentOnCamera(this);
  }

  String tileTypeBelow() {
    final map = gameRef?.map;
    if (map != null && map.tiles.isNotEmpty) {
      Rect position =
          (this is ObjectCollision) ? (this as ObjectCollision).getRectCollision(this.position) : this.position;
      final tiles = map
          .getRendered()
          .where((element) => (element.position.overlaps(position) && (element?.type?.isNotEmpty ?? false)));
      if (tiles.isNotEmpty) return tiles.first.type;
    }
    return null;
  }

  List<String> tileTypesBelow() {
    final map = gameRef?.map;
    if (map != null && map.tiles.isNotEmpty) {
      Rect position =
          (this is ObjectCollision) ? (this as ObjectCollision).getRectCollision(this.position) : this.position;
      return map
          .getRendered()
          .where((element) => (element.position.overlaps(position) && (element?.type?.isNotEmpty ?? false)))
          .map<String>((e) => e.type)
          .toList();
    }
    return null;
  }

  void translate(double translateX, double translateY) {
    position = position.translate(translateX, translateY);
  }
}
