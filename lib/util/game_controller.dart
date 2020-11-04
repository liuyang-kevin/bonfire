import 'package:bonfire/base/rpg_game.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/decoration/decoration.dart';
import 'package:bonfire/enemy/enemy.dart';
import 'package:bonfire/util/camera/camera.dart';
import 'package:little_engine/little_engine.dart';

abstract class GameListener {
  void updateGame();
  void changeCountLiveEnemies(int count);
}

/// game engine loop 回调控制器,负责
class GameController with StitchUpEngineRef<RPGGameEngine> {
  GameListener _gameListener;
  int _lastCountLiveEnemies = 0;

  void addGameComponent(GameComponent component) {
    gameRef.addGameComponent(component);
  }

  void setListener(GameListener listener) {
    _gameListener = listener;
  }

  void notifyListeners() {
    bool notifyChangeEnemy = false;
    int countLive = livingEnemies.length;
    // 计算是否与上次敌人数量一样,减少绘制次数
    if (_lastCountLiveEnemies != countLive) {
      _lastCountLiveEnemies = countLive;
      notifyChangeEnemy = true;
    }
    if (_gameListener != null) {
      _gameListener.updateGame(); // 通知游戏逻辑更新
      // 优化过的,通知敌人更新
      if (notifyChangeEnemy) _gameListener.changeCountLiveEnemies(_lastCountLiveEnemies);
    }
  }

  /// 可见装饰物, 相机位移时用于地图可见装饰物重绘等
  Iterable<GameDecoration> get visibleDecorations => gameRef.visibleDecorations();

  /// 全部装饰物
  Iterable<GameDecoration> get allDecorations => gameRef.decorations();

  /// 可见敌人
  Iterable<Enemy> get visibleEnemies => gameRef.visibleEnemies();

  ///
  Iterable<Enemy> get livingEnemies => gameRef.livingEnemies();

  /// 可见component
  Iterable<GameComponent> get visibleComponents => gameRef.visibleComponents();

  /// 玩家
  Player get player => gameRef.player;

  /// 游戏视角摄像机
  Camera get camera => gameRef.gameCamera;
}
