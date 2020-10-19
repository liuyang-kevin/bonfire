import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/util/camera/camera.dart';
import 'package:bonfire/util/gestures/drag_gesture.dart';
import 'package:bonfire/util/gestures/tap_gesture.dart';
import 'package:bonfire/util/mixin/pointer_detector_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:little_engine/little_engine.dart';

///
///
///
abstract class RPGBaseEngine extends LEStandardEngine with PointerDetector {
  bool _isPause = false;

  /// 可缩放的视角相机
  Camera gameCamera = Camera();

  //region 包含点击事件的组件 与 冒泡分发事件
  Iterable<GameComponent> get _gesturesComponents => components
      .where((c) => ((c is GameComponent && (c.isVisibleInCamera() || c.isHud)) &&
          ((c is TapGesture && (c).enableTab) || (c is DragGesture && (c).enableDrag))))
      .cast<GameComponent>();

  Iterable<PointerDetector> get _pointerDetectorComponents => components.where((c) => (c is PointerDetector)).cast();

  void onPointerCancel(PointerCancelEvent event) {
    _pointerDetectorComponents.forEach((c) => c.onPointerCancel(event));
  }

  void onPointerUp(PointerUpEvent event) {
    for (final c in _gesturesComponents) {
      c.handlerPointerUp(
        event.pointer,
        event.localPosition,
      );
    }
    for (final c in _pointerDetectorComponents) {
      c.onPointerUp(event);
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    _gesturesComponents.where((element) => element is DragGesture).forEach((element) {
      element.handlerPointerMove(event.pointer, event.localPosition);
    });
    for (final c in _pointerDetectorComponents) {
      c.onPointerMove(event);
    }
  }

  void onPointerDown(PointerDownEvent event) {
    for (final c in _gesturesComponents) {
      c.handlerPointerDown(event.pointer, event.localPosition);
    }

    for (final c in _pointerDetectorComponents) {
      c.onPointerDown(event);
    }
  }
  //endregion

  /// 重写render,根据gameCamera定位画面
  ///
  /// This implementation of render basically calls [renderComponent] for every component, making sure the canvas is reset for each one.
  ///
  /// You can override it further to add more custom behaviour.
  /// Beware of however you are rendering components if not using this; you must be careful to save and restore the canvas to avoid components messing up with each other.
  @override
  void render(Canvas canvas, Offset offset) {
    canvas.save();
    // gameCamera定位画面
    canvas.translate(size.width / 2, size.height / 2); // 实现->左上角居中
    canvas.scale(gameCamera.zoom); // 居中缩放
    canvas.translate(-gameCamera.position.x, -gameCamera.position.y); // 偏移到游戏摄影机
    // 布局控件
    components.forEach((comp) => renderComponent(canvas, comp, offset));
    // 引擎camera偏移
    // canvas.translate(-camera.x - 300, -camera.y); // 偏移到全局摄影机
    canvas.restore();
  }

  /// This renders a single component obeying BaseGame rules.
  ///
  /// It translates the camera unless hud, call the render method and restore the canvas.
  /// This makes sure the canvas is not messed up by one component and all components render independently.
  @override
  void renderComponent(Canvas canvas, Component comp, Offset offset) {
    if (!comp.loaded) return;
    if (comp is GameComponent) {
      if (!comp.isHud && !comp.isVisibleInCamera()) return;
    }

    canvas.save();

    // 引擎camera偏移
    canvas.translate(camera.x, camera.y); // 偏移到全局摄影机

    if (comp.isHud) {
      canvas.translate(gameCamera.position.x, gameCamera.position.y);
      canvas.scale(1 / gameCamera.zoom);
      canvas.translate(-size.width / 2, -size.height / 2);
    }

    comp.render(canvas, offset);
    canvas.restore();
  }

  /// 更新绘制
  /// _isPause 标记 暂停游戏
  ///
  /// This implementation of update updates every component in the list.
  ///
  /// It also actually adds the components that were added by the [addLater] method, and remove those that are marked for destruction via the [Component.destroy] method.
  /// You can override it further to add more custom behaviour.
  @override
  void update(double dt) {
    if (_isPause) return;
    super.update(dt);
    gameCamera.update();
  }

  void pause() {
    _isPause = true;
  }

  void resume() {
    _isPause = false;
  }

  bool get isGamePaused => _isPause;
}
