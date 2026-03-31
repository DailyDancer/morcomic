import 'dart:ui';

import 'app_colors.dart';

enum ShapeState {
  sphere,
  apex,
  block;

  Color get color {
    switch (this) {
      case ShapeState.sphere:
        return AppColors.sphereCyan;
      case ShapeState.apex:
        return AppColors.apexMagenta;
      case ShapeState.block:
        return AppColors.blockYellow;
    }
  }
}
