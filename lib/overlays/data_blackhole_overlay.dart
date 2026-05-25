import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/neon_grid_action_runner_game.dart';
import '../widgets/app_background.dart';

class DataBlackholeOverlay extends StatelessWidget {
  const DataBlackholeOverlay({super.key, required this.game});

  final NeonGridActionRunnerGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InnerPageBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      game.overlays.remove('DataBlackhole');
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
                        'DATA BLACKHOLE',
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'Neon Grid Action Runner is a fully offline game. It does not collect, '
                    'store, or transmit any personal data, usage analytics, or '
                    'telemetry. All game data (scores, preferences, purchases) '
                    'is stored locally on your device.\n\n'
                    'No internet connection is required to play Neon Grid Action Runner. '
                    'The game contains no advertisements, no third-party SDKs '
                    'that collect data, and no account system.\n\n'
                    'Your privacy is fully respected. What happens on your '
                    'device stays on your device.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
