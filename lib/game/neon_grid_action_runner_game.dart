import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/player.dart';
import '../components/star_field.dart';
import '../config/app_colors.dart';
import '../config/game_config.dart';
import '../config/shape_state.dart';
import '../services/haptic_service.dart';
import '../services/storage_service.dart';
import 'gate_manager.dart';

class NeonGridActionRunnerGame extends FlameGame
    with HasCollisionDetection, DragCallbacks, TapCallbacks {
  late Player player;
  late GateManager gateManager;
  late StarField starField;

  static const double _swipeThreshold = 30.0;
  static const double _autoRevertDelay = 1.5;

  double _revertTimer = 0;
  bool _isRunning = false;
  bool get isRunning => _isRunning;

  double gateSpeed = GameConfig.speedAlpha;
  double gateInterval = GameConfig.intervalAlpha;

  // Score
  double _lightyears = 0;
  double get lightyears => _lightyears;

  int _runStarBits = 0;
  int get runStarBits => _runStarBits;

  String _currentSector = 'Sector Alpha';
  String get currentSector => _currentSector;

  // Tracks whether we're in a paused gameplay state (for calibrations return)
  bool _isPausedMidGame = false;
  bool get isPausedMidGame => _isPausedMidGame;

  // Visual effects
  double _gatePassGlow = 0;
  double _crashShakeTimer = 0;
  double _crashFlashOpacity = 0;

  @override
  Color backgroundColor() => AppColors.deepSpace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    starField = StarField();
    add(starField);

    gateManager = GateManager();
    add(gateManager);
  }

  void startGame() {
    _isRunning = true;
    _lightyears = 0;
    _runStarBits = 0;
    _revertTimer = 0;
    _gatePassGlow = 0;
    _crashShakeTimer = 0;
    _crashFlashOpacity = 0;

    gateSpeed = GameConfig.speedAlpha;
    gateInterval = GameConfig.intervalAlpha;
    _currentSector = 'Sector Alpha';

    gateManager.reset();

    player = Player()
      ..position = Vector2(size.x * 0.2, size.y * 0.5)
      ..anchor = Anchor.center;
    add(player);
  }

  void stopGame() {
    _isRunning = false;
  }

  void resetGame() {
    gateManager.reset();
    children.whereType<Player>().toList().forEach((p) => p.removeFromParent());
    _isRunning = false;
    _isPausedMidGame = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_crashShakeTimer > 0) {
      _crashShakeTimer -= dt;
    }
    if (_crashFlashOpacity > 0) {
      _crashFlashOpacity = (_crashFlashOpacity - dt * 4).clamp(0.0, 1.0);
    }
    if (_gatePassGlow > 0) {
      _gatePassGlow = (_gatePassGlow - dt * 5).clamp(0.0, 1.0);
    }

    if (!_isRunning) return;

    // Auto-revert to sphere
    if (player.currentShape != ShapeState.sphere) {
      _revertTimer += dt;
      if (_revertTimer >= _autoRevertDelay) {
        player.morph(ShapeState.sphere);
        _revertTimer = 0;
      }
    }

    // Score accumulation
    final speedFactor = gateSpeed / GameConfig.speedAlpha;
    _lightyears += GameConfig.baseScoreRate * speedFactor * dt;

    // Difficulty scaling
    final (speed, interval, name) = GameConfig.sectorFor(_lightyears);
    gateSpeed = speed;
    gateInterval = interval;
    _currentSector = name;
  }

  @override
  void render(Canvas canvas) {
    if (_crashShakeTimer > 0) {
      final shakeOffset = ((_crashShakeTimer * 50).toInt() % 2 == 0 ? 4.0 : -4.0);
      canvas.translate(shakeOffset, shakeOffset * 0.5);
    }

    super.render(canvas);

    // Crash flash overlay
    if (_crashFlashOpacity > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = AppColors.failCrash.withValues(alpha: _crashFlashOpacity * 0.3),
      );
    }
  }

  // --- Input ---

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isRunning) return;

    final vy = event.velocity.y;
    if (vy < -_swipeThreshold) {
      player.morph(ShapeState.apex);
      _revertTimer = 0;
      HapticService.lightImpact();
    } else if (vy > _swipeThreshold) {
      player.morph(ShapeState.block);
      _revertTimer = 0;
      HapticService.lightImpact();
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!_isRunning) return;
    player.morph(ShapeState.sphere);
    _revertTimer = 0;
    HapticService.lightImpact();
  }

  // --- Game Events ---

  void onGatePassed() {
    _gatePassGlow = 1.0;
    player.triggerPassGlow();
  }

  void onStarBitCollected() {
    _runStarBits++;
    HapticService.mediumImpact();
  }

  void onFormCollapsed() {
    _isRunning = false;
    _crashShakeTimer = 0.4;
    _crashFlashOpacity = 1.0;
    HapticService.heavyImpact();

    StorageService.instance.addStarBits(_runStarBits);
    StorageService.instance.updateSectorBest(_lightyears);

    overlays.remove('GameHUD');
    pauseEngine();
    overlays.add('FormCollapsed');
  }

  void onPauseRequested() {
    if (!_isRunning) return;
    _isRunning = false;
    _isPausedMidGame = true;
    pauseEngine();
    overlays.add('TemporalStasis');
  }

  void onResumeGame() {
    _isRunning = true;
    _isPausedMidGame = false;
    resumeEngine();
  }
}
