import 'package:bonfire/base/game_component.dart';
import 'package:flutter/widgets.dart';

mixin StitchAttacker on GameComponent {
  bool isAttackPlayer = false;
  bool isAttackEnemy = false;
  void receiveDamage(double damage, dynamic from);
  Rect get attackScope;
}
