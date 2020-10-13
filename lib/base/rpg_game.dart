import 'package:bonfire/base/base_game_point_detector.dart';
import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:bonfire/enemy/enemy.dart';
import 'package:bonfire/game_interface/game_interface.dart';
import 'package:bonfire/joystick/joystick_controller.dart';
import 'package:bonfire/lighting/lighting.dart';
import 'package:bonfire/lighting/lighting_component.dart';
import 'package:bonfire/player/player.dart';
import 'package:bonfire/util/camera/camera.dart';
import 'package:bonfire/util/color_filter_component.dart';
import 'package:bonfire/util/game_color_filter.dart';
import 'package:bonfire/util/game_controller.dart';
import 'package:bonfire/util/interval_tick.dart';
import 'package:bonfire/util/map_explorer.dart';
import 'package:bonfire/util/mixin/attacker.dart';
import 'package:bonfire/util/value_generator_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_engine/little_engine.dart' hide JoystickController;

import 'base_game_point_detector.dart';

class RPGGameEngine extends RPGBaseEngine with KeyboardEvents {
  final BuildContext context;
  final Player player;
  final GameInterface interface;
  final MapComp map;
  final JoystickController joystickController;
  final GameComponent background;
  final bool constructionMode;
  final bool showCollisionArea;
  final bool showFPS;
  final GameController gameController;
  final Color constructionModeColor;
  final Color lightingColorGame;
  final Color collisionAreaColor;

  Iterable<Enemy> _enemies = List();
  Iterable<Enemy> _visibleEnemies = List();
  Iterable<Enemy> _livingEnemies = List();
  Iterable<StitchAttacker> _attackers = List();
  Iterable<GameDecoration> _decorations = List();
  Iterable<GameDecoration> _visibleDecorations = List();
  Iterable<Lighting> _visibleLights = List();
  Iterable<GameComponent> _visibleComponents = List();
  Iterable<Sensor> _visibleSensors = List();
  IntervalTick _interval;
  ColorFilterComponent _colorFilterComponent = ColorFilterComponent(GameColorFilter());
  LightingComponent lighting;

  RPGGameEngine({
    @required this.context,
    this.map,
    this.joystickController,
    this.player,
    this.interface,
    List<Enemy> enemies,
    List<GameDecoration> decorations,
    List<GameComponent> components,
    this.background,
    this.constructionMode = false,
    this.showCollisionArea = false,
    this.showFPS = false,
    this.gameController,
    this.constructionModeColor,
    this.collisionAreaColor,
    this.lightingColorGame,
    GameColorFilter colorFilter,
    double cameraZoom,
    Size cameraSizeMovementWindow = const Size(50, 50),
    bool cameraMoveOnlyMapArea = false,
  }) : assert(context != null) {
    //region 色彩过滤
    if (colorFilter != null) _colorFilterComponent = ColorFilterComponent(colorFilter);
    _colorFilterComponent.gameRef = this;
    super.addComponent(_colorFilterComponent);
    //endregion
    gameCamera = Camera(
      zoom: cameraZoom ?? 1.0,
      sizeMovementWindow: cameraSizeMovementWindow,
      moveOnlyMapArea: cameraMoveOnlyMapArea,
      target: player,
    );
    gameCamera.gameRef = this;
    gameController?.gameRef = this;
    if (background != null) super.addComponent(background); // 背景
    if (map != null) super.addComponent(map); // 地图
    decorations?.forEach((decoration) => super.addComponent(decoration)); // 装饰器
    enemies?.forEach((enemy) => super.addComponent(enemy)); // 敌人
    components?.forEach((comp) => super.addComponent(comp)); // 其他组件?
    if (player != null) super.addComponent(player); // 玩家
    lighting = LightingComponent(color: lightingColorGame);
    super.addComponent(lighting); // 视野,光源
    super.addComponent((interface ?? GameInterface())); // 输入组件
    super.addComponent(joystickController ?? Joystick()); // 虚拟摇杆
    joystickController?.addObserver(player ?? MapExplorer(gameCamera));
    _interval = IntervalTick(200, tick: _updateTempList);
  }

  @override
  void update(double t) {
    _interval.update(t);
    super.update(t);
  }

  void addGameComponent(GameComponent component) {
    addComponentLater(component);
  }

  Iterable<GameComponent> visibleComponents() => _visibleComponents;
  Iterable<Enemy> visibleEnemies() => _visibleEnemies;

  Iterable<Enemy> livingEnemies() => _livingEnemies;

  Iterable<GameDecoration> visibleDecorations() => _visibleDecorations;

  Iterable<Enemy> enemies() => _enemies;

  Iterable<GameDecoration> decorations() => _decorations;

  Iterable<Lighting> lightVisible() => _visibleLights;

  Iterable<StitchAttacker> attackers() => _attackers;
  Iterable<Sensor> visibleSensors() => _visibleSensors;

  ValueGeneratorComponent getValueGenerator(
    Duration duration, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.decelerate,
    VoidCallback onFinish,
    ValueChanged<double> onChange,
  }) {
    final valueGenerator = ValueGeneratorComponent(
      duration,
      end: end,
      begin: begin,
      curve: curve,
      onFinish: onFinish,
      onChange: onChange,
    );
    addComponentLater(valueGenerator);
    return valueGenerator;
  }

  @override
  void onKeyEvent(RawKeyEvent event) {
    joystickController?.onKeyboard(event);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _updateTempList();
  }

  void _updateTempList() {
    _visibleComponents = components.where((element) {
      return (element is GameComponent) && (element).isVisibleInCamera();
    }).cast();

    _decorations = components.where((element) {
      return (element is GameDecoration);
    }).cast();
    _visibleDecorations = _decorations.where((element) {
      return element.isVisibleInCamera();
    });

    _enemies = components.where((element) => (element is Enemy)).cast();
    _livingEnemies = _enemies.where((element) => !element.isDead).cast();
    _visibleEnemies = _livingEnemies.where((element) {
      return element.isVisibleInCamera();
    });

    _visibleSensors = _visibleComponents.where((element) => (element is Sensor)).cast();
    _attackers = _visibleComponents.where((element) => (element is StitchAttacker)).cast();

    if (lightingColorGame != null) {
      _visibleLights = components.where((element) {
        return element is Lighting && (element as Lighting).isVisible(gameCamera);
      }).cast();
    }

    if (gameController != null) gameController.notifyListeners();
  }

  @override
  bool get recordFps => showFPS;

  GameColorFilter get colorFilter => _colorFilterComponent.colorFilter;
}
