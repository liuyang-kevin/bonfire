/// 布局优先级
class PriorityLayer {
  static const int MAP = 20;
  static const int DECORATION = 30;
  static const int ENEMY = 40;
  static const int PLAYER = 50;
  static const int OBJECTS = 60; // 对游戏没有太多影响的对象,如:"攻击数值"
  static const int LIGHTING = 80; // 照明；灯光；布光
  static const int GAME_INTERFACE = 90;
  static const int JOYSTICK = 100;
}
