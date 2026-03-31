import 'package:flutter/services.dart';

import 'storage_service.dart';

abstract final class HapticService {
  static void lightImpact() {
    if (!StorageService.instance.hapticsEnabled) return;
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    if (!StorageService.instance.hapticsEnabled) return;
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    if (!StorageService.instance.hapticsEnabled) return;
    HapticFeedback.heavyImpact();
  }
}
