import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/neon_grid_action_runner_game.dart';
import '../services/storage_service.dart';

class FormCollapsedOverlay extends StatelessWidget {
  const FormCollapsedOverlay({super.key, required this.game});

  final NeonGridActionRunnerGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sectorBest = StorageService.instance.sectorBest;

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
                  'FORM\nCOLLAPSED',
                  textAlign: TextAlign.center,
                  style: textTheme.displayMedium?.copyWith(
                    color: AppColors.failCrash,
                  ),
                ),
                const SizedBox(height: 32),

                // Run stats
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.stardust,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _StatRow(
                        label: 'LIGHTYEARS',
                        value: '${game.lightyears.toInt()} LY',
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        label: 'STAR BITS',
                        value: '+${game.runStarBits}',
                        color: AppColors.sphereCyan,
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        label: 'SECTOR BEST',
                        value: '${sectorBest.toInt()} LY',
                        color: AppColors.blockYellow,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _ActionButton(
                  label: 'RE-INITIATE WARP',
                  isPrimary: true,
                  onPressed: () {
                    game.overlays.remove('FormCollapsed');
                    game.resetGame();
                    game.resumeEngine();
                    game.overlays.add('GameHUD');
                    game.startGame();
                  },
                ),
                const SizedBox(height: 16),
                _ActionButton(
                  label: 'RETURN TO HUB',
                  isPrimary: false,
                  onPressed: () {
                    game.overlays.remove('FormCollapsed');
                    game.resetGame();
                    game.resumeEngine();
                    game.overlays.add('CosmicHub');
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

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.white54),
        ),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
