import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/cosmic_morph_game.dart';
import '../services/storage_service.dart';

class CalibrationsOverlay extends StatefulWidget {
  const CalibrationsOverlay({super.key, required this.game});

  final CosmicMorphGame game;

  @override
  State<CalibrationsOverlay> createState() => _CalibrationsOverlayState();
}

class _CalibrationsOverlayState extends State<CalibrationsOverlay> {
  late bool _hapticsEnabled;

  @override
  void initState() {
    super.initState();
    _hapticsEnabled = StorageService.instance.hapticsEnabled;
  }

  String get _returnOverlay {
    if (widget.game.isPausedMidGame) return 'TemporalStasis';
    return 'CosmicHub';
  }

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
                      widget.game.overlays.remove('Calibrations');
                      widget.game.overlays.add(_returnOverlay);
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
                  Text(
                    'CALIBRATIONS',
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.stardust,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HAPTICS',
                      style: textTheme.labelLarge?.copyWith(fontSize: 18),
                    ),
                    Switch(
                      value: _hapticsEnabled,
                      activeThumbColor: AppColors.sphereCyan,
                      inactiveThumbColor: Colors.white38,
                      inactiveTrackColor: Colors.white10,
                      onChanged: (value) {
                        setState(() {
                          _hapticsEnabled = value;
                        });
                        StorageService.instance.setHapticsEnabled(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
