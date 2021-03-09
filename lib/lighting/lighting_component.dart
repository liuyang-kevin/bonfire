import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/lighting/lighting.dart';
import 'package:bonfire/util/priority_layer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 光源组件,其实就是视野等遮罩
class LightingComponent extends GameComponent {
  Color color;
  Paint _paintFocus;
  Iterable<Lighting> _visibleLight = List();
  double _dtUpdate = 0.0;
  ColorTween _tween;

  @override
  bool get isHud => true;

  LightingComponent({this.color}) {
    if (kIsWeb) {
      // _paintFocus = Paint()..blendMode = BlendMode.xor;
      _paintFocus = Paint()..blendMode = BlendMode.xor;
    } else {
      _paintFocus = Paint()..blendMode = BlendMode.clear;
    }
  }

  @override
  int get priority => PriorityLayer.LIGHTING;

  @override
  void render(Canvas canvas, Offset offset) {
    if (color == null) return;
    Size size = gameRef.size;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawColor(color, BlendMode.dstATop);
    _visibleLight.forEach((light) {
      final config = light.lightingConfig;
      final sigma = _convertRadiusToSigma(config.blurBorder);
      config.update(_dtUpdate);
      canvas.save();

      canvas.translate(size.width / 2, size.height / 2);
      canvas.scale(gameRef.gameCamera.zoom);
      canvas.translate(-gameRef.gameCamera.position.x, -gameRef.gameCamera.position.y);
      if (kIsWeb) {
        _paintFocus.maskFilter = MaskFilter.blur(BlurStyle.outer, sigma);
      } else {
        _paintFocus.maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);
      }
      canvas.drawCircle(
        Offset(light.gameComponent.position.center.dx, light.gameComponent.position.center.dy),
        config.radius * (config.withPulse ? (1 - config.valuePulse * config.pulseVariation) : 1),
        _paintFocus,
      );

      if (config.color != null) {
        final Paint paint = Paint()
          ..color = config.color
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            sigma,
          );
        canvas.drawCircle(
          Offset(
            light.gameComponent.position.center.dx,
            light.gameComponent.position.center.dy,
          ),
          config.radius * (config.withPulse ? (1 - config.valuePulse * config.pulseVariation) : 1),
          paint,
        );
      }
      canvas.restore();
    });
    canvas.restore();
  }

  static double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  void update(double dt) {
    if (color == null) return;
    _dtUpdate = dt;
    _visibleLight = gameRef.lightVisible();
  }

  void animateColorTo(
    Color color, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.decelerate,
  }) {
    _tween = ColorTween(begin: this.color ?? Colors.transparent, end: color);

    gameRef.getValueGenerator(
      duration ?? Duration(seconds: 1),
      onChange: (value) {
        this.color = _tween.transform(value);
      },
      onFinish: () {
        this.color = color;
      },
      curve: curve,
    ).start();
  }
}
