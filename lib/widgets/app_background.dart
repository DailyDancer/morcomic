import 'package:flutter/material.dart';

import '../config/app_colors.dart';

abstract final class AppAssets {
  static const menuBackground = 'assets/images/menubg.png';
  static const innerPageBackground = 'assets/images/innerpagebg.png';
}

class MenuBackground extends StatelessWidget {
  const MenuBackground({super.key, required this.child});

  final Widget child;

  static const _backgroundOpacity = 0.25;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deepSpace,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: _backgroundOpacity,
            child: Image.asset(
              AppAssets.menuBackground,
              fit: BoxFit.cover,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class InnerPageBackground extends StatelessWidget {
  const InnerPageBackground({super.key, required this.child});

  final Widget child;

  static const _backgroundOpacity = 0.30;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deepSpace,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: _backgroundOpacity,
            child: Image.asset(
              AppAssets.innerPageBackground,
              fit: BoxFit.cover,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
