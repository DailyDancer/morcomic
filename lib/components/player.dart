import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../config/shape_state.dart';
import '../config/skin_data.dart';
import '../services/storage_service.dart';

class Player extends PositionComponent with CollisionCallbacks {
  Player()
      : super(
          size: Vector2.all(60),
        );

  ShapeState _currentShape = ShapeState.sphere;
  ShapeState get currentShape => _currentShape;

  final Paint _paint = Paint();
  final Paint _glowPaint = Paint();

  double _morphScale = 1.0;
  double _morphTimer = 0;
  static const double _morphDuration = 0.15;
  bool _isMorphing = false;

  double _passGlow = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    _updatePaint();
  }

  void morph(ShapeState newShape) {
    if (_currentShape == newShape) return;
    _currentShape = newShape;
    _isMorphing = true;
    _morphTimer = 0;
    _updatePaint();
  }

  void triggerPassGlow() {
    _passGlow = 1.0;
  }

  Color _colorForShape(ShapeState shape) {
    final skin = SkinData.getById(StorageService.instance.equippedSkin);
    switch (shape) {
      case ShapeState.sphere:
        return skin.sphereColor;
      case ShapeState.apex:
        return skin.apexColor;
      case ShapeState.block:
        return skin.blockColor;
    }
  }

  void _updatePaint() {
    final color = _colorForShape(_currentShape);
    _paint
      ..color = color
      ..style = PaintingStyle.fill;
    _glowPaint
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isMorphing) {
      _morphTimer += dt;
      final progress = (_morphTimer / _morphDuration).clamp(0.0, 1.0);

      if (progress < 0.5) {
        _morphScale = 1.0 - 0.3 * (progress / 0.5);
      } else {
        _morphScale = 0.7 + 0.3 * ((progress - 0.5) / 0.5);
      }

      if (progress >= 1.0) {
        _isMorphing = false;
        _morphScale = 1.0;
      }
    }

    if (_passGlow > 0) {
      _passGlow = (_passGlow - dt * 5).clamp(0.0, 1.0);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.translate(cx, cy);
    canvas.scale(_morphScale, 2.0 - _morphScale);

    if (_passGlow > 0) {
      final glowRadius = size.x * 0.8;
      final passGlowPaint = Paint()
        ..color = _colorForShape(_currentShape).withValues(alpha: _passGlow * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(Offset.zero, glowRadius, passGlowPaint);
    }

    switch (_currentShape) {
      case ShapeState.sphere:
        _renderSphere(canvas);
      case ShapeState.apex:
        _renderApex(canvas);
      case ShapeState.block:
        _renderBlock(canvas);
    }

    canvas.restore();
  }

  void _renderSphere(Canvas canvas) {
    final radius = size.x / 2;
    canvas.drawCircle(Offset.zero, radius + 4, _glowPaint);
    canvas.drawCircle(Offset.zero, radius, _paint);
  }

  void _renderApex(Canvas canvas) {
    final halfW = size.x / 2;
    final halfH = size.y / 2;
    final path = Path()
      ..moveTo(0, -halfH)
      ..lineTo(halfW, halfH)
      ..lineTo(-halfW, halfH)
      ..close();

    final glowPath = Path()
      ..moveTo(0, -halfH - 4)
      ..lineTo(halfW + 4, halfH + 4)
      ..lineTo(-halfW - 4, halfH + 4)
      ..close();

    canvas.drawPath(glowPath, _glowPaint);
    canvas.drawPath(path, _paint);
  }

  void _renderBlock(Canvas canvas) {
    final rect = Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y);
    final glowRect = Rect.fromCenter(
      center: Offset.zero,
      width: size.x + 8,
      height: size.y + 8,
    );

    canvas.drawRect(glowRect, _glowPaint);
    canvas.drawRect(rect, _paint);
  }
}
