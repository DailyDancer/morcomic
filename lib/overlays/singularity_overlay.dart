import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../game/cosmic_morph_game.dart';

class SingularityOverlay extends StatefulWidget {
  const SingularityOverlay({super.key, required this.game});

  final CosmicMorphGame game;

  @override
  State<SingularityOverlay> createState() => _SingularityOverlayState();
}

class _SingularityOverlayState extends State<SingularityOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.game.overlays.remove('Singularity');
        widget.game.overlays.add('CosmicHub');
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.deepSpace,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 160,
                height: 160,
              ),
              const SizedBox(height: 24),
              Text(
                'COSMIC\nMORPH',
                textAlign: TextAlign.center,
                style: textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
