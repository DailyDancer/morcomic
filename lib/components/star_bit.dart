import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/neon_grid_action_runner_game.dart';
import 'player.dart';

class StarBit extends PositionComponent
    with CollisionCallbacks, HasGameReference<NeonGridActionRunnerGame> {
  StarBit() : super(size: Vector2.all(20), anchor: Anchor.center);

  bool isVisible = false;

  bool _isCollecting = false;
  double _collectTimer = 0;
  static const double _collectDuration = 0.2;

  double _collectScale = 1.0;
  double _collectOpacity = 1.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  void recycle(Vector2 newPosition) {
    isVisible = true;
    _isCollecting = false;
    _collectTimer = 0;
    _collectScale = 1.0;
    _collectOpacity = 1.0;
    position.setFrom(newPosition);
  }

  void deactivate() {
    isVisible = false;
    _isCollecting = false;
    position.setValues(-200, -200);
  }

  void collect() {
    if (_isCollecting) return;
    _isCollecting = true;
    _collectTimer = 0;
    game.onStarBitCollected();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isVisible) return;

    position.x -= game.gateSpeed * dt;

    if (position.x < -size.x) {
      deactivate();
      return;
    }

    if (_isCollecting) {
      _collectTimer += dt;
      final progress = (_collectTimer / _collectDuration).clamp(0.0, 1.0);
      _collectScale = 1.0 - progress;
      _collectOpacity = 1.0 - progress;

      if (progress >= 1.0) {
        deactivate();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible) return;

    canvas.save();

    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.translate(cx, cy);
    canvas.scale(_collectScale);

    final glowPaint = Paint()
      ..color = AppColors.sphereCyan.withValues(alpha: 0.4 * _collectOpacity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final corePaint = Paint()
      ..color = AppColors.starBitWhite.withValues(alpha: _collectOpacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, size.x / 2 + 4, glowPaint);
    canvas.drawCircle(Offset.zero, size.x / 2 * 0.6, corePaint);

    canvas.restore();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player && isVisible && !_isCollecting) {
      collect();
    }
  }
}
