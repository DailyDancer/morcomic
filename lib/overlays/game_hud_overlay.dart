import 'dart:async';

import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/neon_grid_action_runner_game.dart';

class GameHudOverlay extends StatefulWidget {
  const GameHudOverlay({super.key, required this.game});

  final NeonGridActionRunnerGame game;

  @override
  State<GameHudOverlay> createState() => _GameHudOverlayState();
}

class _GameHudOverlayState extends State<GameHudOverlay> {
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final game = widget.game;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${game.lightyears.toInt()} LY',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.starBitWhite,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.sphereCyan,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${game.runStarBits}',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    game.overlays.remove('GameHUD');
                    game.onPauseRequested();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.stardust, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
