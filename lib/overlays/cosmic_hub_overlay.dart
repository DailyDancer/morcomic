import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/neon_grid_action_runner_game.dart';
import '../services/storage_service.dart';
import '../widgets/app_background.dart';

class CosmicHubOverlay extends StatelessWidget {
  const CosmicHubOverlay({super.key, required this.game});

  final NeonGridActionRunnerGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MenuBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 16),
              Text(
                'NEON GRID ACTION RUNNER',
                style: textTheme.displayMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                '${StorageService.instance.starBits} Star Bits',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.sphereCyan,
                ),
              ),
              const Spacer(flex: 3),

              // Primary button
              _HubButton(
                label: 'WARP IN',
                isPrimary: true,
                onPressed: () {
                  game.overlays.remove('CosmicHub');
                  game.overlays.add('GameHUD');
                  game.resumeEngine();
                  game.startGame();
                },
              ),
              const SizedBox(height: 16),

              // Secondary buttons
              _HubButton(
                label: 'MORPHING MANUAL',
                isPrimary: false,
                onPressed: () {
                  game.overlays.remove('CosmicHub');
                  game.overlays.add('MorphingManual');
                },
              ),
              const SizedBox(height: 12),
              _HubButton(
                label: 'CALIBRATIONS',
                isPrimary: false,
                onPressed: () {
                  game.overlays.remove('CosmicHub');
                  game.overlays.add('Calibrations');
                },
              ),
              const SizedBox(height: 12),
              _HubButton(
                label: 'THE ARSENAL',
                isPrimary: false,
                onPressed: () {
                  game.overlays.remove('CosmicHub');
                  game.overlays.add('Arsenal');
                },
              ),
              const SizedBox(height: 12),
              _HubButton(
                label: 'DATA BLACKHOLE',
                isPrimary: false,
                onPressed: () {
                  game.overlays.remove('CosmicHub');
                  game.overlays.add('DataBlackhole');
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubButton extends StatelessWidget {
  const _HubButton({
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
                fontSize: isPrimary ? 24 : 18,
              ),
        ),
      ),
    );
  }
}
