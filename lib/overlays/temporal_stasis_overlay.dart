import 'dart:async';

import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/cosmic_morph_game.dart';

class TemporalStasisOverlay extends StatefulWidget {
  const TemporalStasisOverlay({super.key, required this.game});

  final CosmicMorphGame game;

  @override
  State<TemporalStasisOverlay> createState() => _TemporalStasisOverlayState();
}

class _TemporalStasisOverlayState extends State<TemporalStasisOverlay> {
  bool _isCountingDown = false;
  int _countdownValue = 3;

  void _startResume() {
    setState(() {
      _isCountingDown = true;
      _countdownValue = 3;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _countdownValue--;
      });

      if (_countdownValue <= 0) {
        timer.cancel();
        widget.game.overlays.remove('TemporalStasis');
        widget.game.overlays.add('GameHUD');
        widget.game.onResumeGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_isCountingDown) {
      return Container(
        color: AppColors.deepSpace.withValues(alpha: 0.85),
        child: Center(
          child: Text(
            '$_countdownValue',
            style: textTheme.displayLarge?.copyWith(
              color: AppColors.sphereCyan,
              fontSize: 96,
            ),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.deepSpace.withValues(alpha: 0.85),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TEMPORAL\nSTASIS',
                  textAlign: TextAlign.center,
                  style: textTheme.displayMedium?.copyWith(
                    color: AppColors.sphereCyan,
                  ),
                ),
                const SizedBox(height: 48),
                _StasisButton(
                  label: 'BREAK STASIS',
                  isPrimary: true,
                  onPressed: _startResume,
                ),
                const SizedBox(height: 16),
                _StasisButton(
                  label: 'CALIBRATIONS',
                  isPrimary: false,
                  onPressed: () {
                    widget.game.overlays.remove('TemporalStasis');
                    widget.game.overlays.add('Calibrations');
                  },
                ),
                const SizedBox(height: 16),
                _StasisButton(
                  label: 'ABANDON ORBIT',
                  isPrimary: false,
                  onPressed: () {
                    widget.game.overlays.remove('TemporalStasis');
                    widget.game.resetGame();
                    widget.game.resumeEngine();
                    widget.game.overlays.add('CosmicHub');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StasisButton extends StatelessWidget {
  const _StasisButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isPrimary ? AppColors.sphereCyan : AppColors.stardust,
            width: isPrimary ? 2 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isPrimary ? AppColors.sphereCyan : Colors.white70,
              ),
        ),
      ),
    );
  }
}
