import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const _fontFamily = 'Orbitron';

  static ThemeData get theme {
    final baseText = ThemeData.dark().textTheme.apply(fontFamily: _fontFamily);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepSpace,
      textTheme: baseText.copyWith(
        displayLarge: baseText.displayLarge?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 64,
          color: Colors.white,
        ),
        displayMedium: baseText.displayMedium?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 48,
          color: Colors.white,
        ),
        labelLarge: baseText.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 2.0,
          color: Colors.white,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: Colors.white,
          shadows: [
            const Shadow(blurRadius: 4, color: Colors.black),
          ],
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
        ),
        bodySmall: baseText.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.5,
          color: Colors.white,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        surface: AppColors.deepSpace,
        primary: AppColors.sphereCyan,
        secondary: AppColors.apexMagenta,
        tertiary: AppColors.blockYellow,
        error: AppColors.failCrash,
      ),
    );
  }
}
