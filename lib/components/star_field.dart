import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/neon_grid_action_runner_game.dart';

class _Star {
  double x;
  double y;
  double radius;
  double opacity;
  double speedMultiplier;

  _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.speedMultiplier,
  });
}

class StarFieldLayer extends PositionComponent
    with HasGameReference<NeonGridActionRunnerGame> {
  StarFieldLayer({
    required this.starCount,
    required this.baseSpeed,
    required this.minRadius,
    required this.maxRadius,
    required this.baseOpacity,
  });

  final int starCount;
  final double baseSpeed;
  final double minRadius;
  final double maxRadius;
  final double baseOpacity;

  final List<_Star> _stars = [];
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;

    for (var i = 0; i < starCount; i++) {
      _stars.add(_Star(
        x: _random.nextDouble() * size.x,
        y: _random.nextDouble() * size.y,
        radius: minRadius + _random.nextDouble() * (maxRadius - minRadius),
        opacity: baseOpacity * (0.5 + _random.nextDouble() * 0.5),
        speedMultiplier: 0.8 + _random.nextDouble() * 0.4,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isRunning) return;

    final speedFactor = game.gateSpeed / 200.0;

    for (final star in _stars) {
      star.x -= baseSpeed * speedFactor * star.speedMultiplier * dt;

      if (star.x < -star.radius) {
        star.x = size.x + star.radius;
        star.y = _random.nextDouble() * size.y;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final star in _stars) {
      final paint = Paint()
        ..color = AppColors.starBitWhite.withValues(alpha: star.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(star.x, star.y), star.radius, paint);
    }
  }
}

class StarField extends Component with HasGameReference<NeonGridActionRunnerGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Far layer: small, dim, slow
    add(StarFieldLayer(
      starCount: 40,
      baseSpeed: 15,
      minRadius: 0.5,
      maxRadius: 1.2,
      baseOpacity: 0.3,
    ));

    // Mid layer: medium size, moderate
    add(StarFieldLayer(
      starCount: 25,
      baseSpeed: 30,
      minRadius: 1.0,
      maxRadius: 2.0,
      baseOpacity: 0.5,
    ));

    // Near layer: larger, brighter, faster
    add(StarFieldLayer(
      starCount: 12,
      baseSpeed: 55,
      minRadius: 1.5,
      maxRadius: 3.0,
      baseOpacity: 0.7,
    ));
  }
}
