import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/shape_state.dart';
import '../game/cosmic_morph_game.dart';
import 'player.dart';

class MatterGate extends PositionComponent
    with CollisionCallbacks, HasGameReference<CosmicMorphGame> {
  MatterGate({required ShapeState requiredShape})
      : _requiredShape = requiredShape,
        super(size: Vector2(40, 300));

  ShapeState _requiredShape;
  ShapeState get requiredShape => _requiredShape;

  bool _passed = false;
  bool isVisible = false;

  final Paint _barrierPaint = Paint()
    ..color = AppColors.stardust
    ..style = PaintingStyle.fill;

  final Paint _cutoutBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  static const double _cutoutSize = 70.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    _cutoutBorderPaint.color = _requiredShape.color;
  }

  void recycle(ShapeState newShape, Vector2 newPosition) {
    _requiredShape = newShape;
    _passed = false;
    isVisible = true;
    position.setFrom(newPosition);
    anchor = Anchor.center;
    _cutoutBorderPaint.color = _requiredShape.color;
  }

  void deactivate() {
    isVisible = false;
    position.setValues(-200, -200);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isVisible) return;

    position.x -= game.gateSpeed * dt;

    if (position.x < -size.x) {
      deactivate();
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible) return;

    final gateRect = size.toRect();
    final centerY = gateRect.height / 2;
    final centerX = gateRect.width / 2;

    canvas.drawRect(
      Rect.fromLTRB(0, 0, gateRect.width, centerY - _cutoutSize / 2),
      _barrierPaint,
    );

    canvas.drawRect(
      Rect.fromLTRB(0, centerY + _cutoutSize / 2, gateRect.width, gateRect.height),
      _barrierPaint,
    );

    _renderCutoutShape(canvas, Offset(centerX, centerY));
  }

  void _renderCutoutShape(Canvas canvas, Offset center) {
    final halfSize = _cutoutSize / 2;

    switch (_requiredShape) {
      case ShapeState.sphere:
        canvas.drawCircle(center, halfSize * 0.6, _cutoutBorderPaint);
      case ShapeState.apex:
        final path = Path()
          ..moveTo(center.dx, center.dy - halfSize * 0.6)
          ..lineTo(center.dx + halfSize * 0.6, center.dy + halfSize * 0.6)
          ..lineTo(center.dx - halfSize * 0.6, center.dy + halfSize * 0.6)
          ..close();
        canvas.drawPath(path, _cutoutBorderPaint);
      case ShapeState.block:
        final rect = Rect.fromCenter(
          center: center,
          width: _cutoutSize * 0.6,
          height: _cutoutSize * 0.6,
        );
        canvas.drawRect(rect, _cutoutBorderPaint);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player && !_passed && isVisible) {
      if (other.currentShape == _requiredShape) {
        _passed = true;
        game.onGatePassed();
      } else {
        game.onFormCollapsed();
      }
    }
  }
}
