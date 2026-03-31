import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/shape_state.dart';
import '../game/cosmic_morph_game.dart';

class MorphingManualOverlay extends StatelessWidget {
  const MorphingManualOverlay({super.key, required this.game});

  final CosmicMorphGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.deepSpace,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      game.overlays.remove('MorphingManual');
                      game.overlays.add('CosmicHub');
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.stardust, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MORPHING MANUAL',
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _ManualPanel(
                label: 'TAP',
                shapeName: 'SPHERE',
                shape: ShapeState.sphere,
                description: 'Tap to return to default form',
              ),
              const SizedBox(height: 24),
              _ManualPanel(
                label: 'SWIPE UP',
                shapeName: 'APEX',
                shape: ShapeState.apex,
                description: 'Swipe up to morph into triangle',
              ),
              const SizedBox(height: 24),
              _ManualPanel(
                label: 'SWIPE DOWN',
                shapeName: 'BLOCK',
                shape: ShapeState.block,
                description: 'Swipe down to morph into square',
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualPanel extends StatelessWidget {
  const _ManualPanel({
    required this.label,
    required this.shapeName,
    required this.shape,
    required this.description,
  });

  final String label;
  final String shapeName;
  final ShapeState shape;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.stardust,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(
              painter: _ShapePainter(shape: shape),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label = $shapeName',
                  style: textTheme.labelLarge?.copyWith(
                    color: shape.color,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter({required this.shape});

  final ShapeState shape;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = shape.color
      ..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..color = shape.color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final halfW = size.width * 0.4;
    final halfH = size.height * 0.4;

    switch (shape) {
      case ShapeState.sphere:
        canvas.drawCircle(Offset(cx, cy), halfW + 2, glowPaint);
        canvas.drawCircle(Offset(cx, cy), halfW, paint);
      case ShapeState.apex:
        final path = Path()
          ..moveTo(cx, cy - halfH)
          ..lineTo(cx + halfW, cy + halfH)
          ..lineTo(cx - halfW, cy + halfH)
          ..close();
        canvas.drawPath(path, glowPaint);
        canvas.drawPath(path, paint);
      case ShapeState.block:
        final rect = Rect.fromCenter(center: Offset(cx, cy), width: halfW * 2, height: halfH * 2);
        canvas.drawRect(rect.inflate(2), glowPaint);
        canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      oldDelegate.shape != shape;
}
