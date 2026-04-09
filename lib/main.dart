import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/app_colors.dart';
import 'config/app_theme.dart';
import 'game/neon_grid_action_runner_game.dart';
import 'overlays/arsenal_overlay.dart';
import 'overlays/calibrations_overlay.dart';
import 'overlays/cosmic_hub_overlay.dart';
import 'overlays/data_blackhole_overlay.dart';
import 'overlays/form_collapsed_overlay.dart';
import 'overlays/game_hud_overlay.dart';
import 'overlays/morphing_manual_overlay.dart';
import 'overlays/singularity_overlay.dart';
import 'overlays/temporal_stasis_overlay.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const GameScreen(),
    ),
  );
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: GameWidget<NeonGridActionRunnerGame>.controlled(
        gameFactory: NeonGridActionRunnerGame.new,
        overlayBuilderMap: {
          'Singularity': (BuildContext context, NeonGridActionRunnerGame game) {
            return SingularityOverlay(game: game);
          },
          'CosmicHub': (BuildContext context, NeonGridActionRunnerGame game) {
            return CosmicHubOverlay(game: game);
          },
          'GameHUD': (BuildContext context, NeonGridActionRunnerGame game) {
            return GameHudOverlay(game: game);
          },
          'TemporalStasis': (BuildContext context, NeonGridActionRunnerGame game) {
            return TemporalStasisOverlay(game: game);
          },
          'FormCollapsed': (BuildContext context, NeonGridActionRunnerGame game) {
            return FormCollapsedOverlay(game: game);
          },
          'MorphingManual': (BuildContext context, NeonGridActionRunnerGame game) {
            return MorphingManualOverlay(game: game);
          },
          'Calibrations': (BuildContext context, NeonGridActionRunnerGame game) {
            return CalibrationsOverlay(game: game);
          },
          'Arsenal': (BuildContext context, NeonGridActionRunnerGame game) {
            return ArsenalOverlay(game: game);
          },
          'DataBlackhole': (BuildContext context, NeonGridActionRunnerGame game) {
            return DataBlackholeOverlay(game: game);
          },
        },
        initialActiveOverlays: const ['Singularity'],
      ),
    );
  }
}
