import 'dart:math';

import 'package:flame/components.dart';

import '../components/matter_gate.dart';
import '../components/star_bit.dart';
import '../config/shape_state.dart';
import 'neon_grid_action_runner_game.dart';

class GateManager extends Component with HasGameReference<NeonGridActionRunnerGame> {
  static const int _poolSize = 5;
  static const int _starBitsPerGap = 3;

  final List<MatterGate> _pool = [];
  final List<StarBit> _starBitPool = [];
  final Random _random = Random();

  double _spawnTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (var i = 0; i < _poolSize; i++) {
      final gate = MatterGate(requiredShape: ShapeState.sphere)..isVisible = false;
      _pool.add(gate);
      add(gate);
    }

    for (var i = 0; i < _poolSize * _starBitsPerGap; i++) {
      final bit = StarBit()..isVisible = false;
      _starBitPool.add(bit);
      add(bit);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isRunning) return;

    _spawnTimer += dt;
    if (_spawnTimer >= game.gateInterval) {
      _spawnTimer = 0;
      _spawnGate();
    }
  }

  void _spawnGate() {
    final gate = _getAvailableGate();
    if (gate == null) return;

    final shapes = ShapeState.values;
    final requiredShape = shapes[_random.nextInt(shapes.length)];

    gate.recycle(
      requiredShape,
      Vector2(game.size.x + 80, game.size.y * 0.5),
    );

    _spawnStarBitsBeforeGate(gate.position.x);
  }

  void _spawnStarBitsBeforeGate(double gateX) {
    final midX = gateX - (game.gateInterval * game.gateSpeed * 0.4);
    final baseY = game.size.y * 0.5;

    for (var i = 0; i < _starBitsPerGap; i++) {
      final bit = _getAvailableStarBit();
      if (bit == null) break;

      final offsetX = (i - 1) * 50.0;
      final offsetY = (_random.nextDouble() - 0.5) * 60;

      bit.recycle(Vector2(midX + offsetX, baseY + offsetY));
    }
  }

  MatterGate? _getAvailableGate() {
    for (final gate in _pool) {
      if (!gate.isVisible) return gate;
    }
    return null;
  }

  StarBit? _getAvailableStarBit() {
    for (final bit in _starBitPool) {
      if (!bit.isVisible) return bit;
    }
    return null;
  }

  void reset() {
    _spawnTimer = 0;
    for (final gate in _pool) {
      gate.deactivate();
    }
    for (final bit in _starBitPool) {
      bit.deactivate();
    }
  }
}
