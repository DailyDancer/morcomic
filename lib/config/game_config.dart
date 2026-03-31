abstract final class GameConfig {
  // Sector thresholds (Lightyears)
  static const double sectorAlphaEnd = 500;
  static const double sectorBetaEnd = 1500;
  static const double sectorGammaEnd = 3000;
  static const double sectorDeltaEnd = 6000;

  // Warp Speed per sector (pixels/second)
  static const double speedAlpha = 120;
  static const double speedBeta = 200;
  static const double speedGamma = 320;
  static const double speedDelta = 450;
  static const double speedDeepVoid = 560;

  // Gate interval per sector (seconds between gates)
  static const double intervalAlpha = 3.2;
  static const double intervalBeta = 2.4;
  static const double intervalGamma = 1.7;
  static const double intervalDelta = 1.2;
  static const double intervalDeepVoid = 0.9;

  // Base score rate (lightyears per second at speed 1.0)
  static const double baseScoreRate = 10.0;

  static (double speed, double interval, String name) sectorFor(double lightyears) {
    if (lightyears < sectorAlphaEnd) {
      return (speedAlpha, intervalAlpha, 'Sector Alpha');
    } else if (lightyears < sectorBetaEnd) {
      return (speedBeta, intervalBeta, 'Sector Beta');
    } else if (lightyears < sectorGammaEnd) {
      return (speedGamma, intervalGamma, 'Sector Gamma');
    } else if (lightyears < sectorDeltaEnd) {
      return (speedDelta, intervalDelta, 'Sector Delta');
    } else {
      return (speedDeepVoid, intervalDeepVoid, 'The Deep Void');
    }
  }
}
