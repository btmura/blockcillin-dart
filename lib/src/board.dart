part of client;

class Board {

  static final double _startRotationY = 0.0;
  static final double _incrementalRotationY = math.PI / 150;

  static final double _startTranslationY = -1.0;
  static final double _incrementalTranslationY = 0.02;

  static final int _numSteps = (1.0 / _incrementalTranslationY).round();

  final List<Ring> rings;
  final int numRings;
  final int numCells;
  final int numBlockColors;

  int _step = 0;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors);

  factory Board.withRandomRings(int numRings, int numCells, int numBlockColors) {
    var rings = new List<Ring>(numRings);
    for (var i = 0; i < numRings; i++) {
      rings[i] = new Ring.withRandomCells(numCells);
    }
    return new Board(rings, numRings, numCells, numBlockColors);
  }

  double get rotationY => _startRotationY + _incrementalRotationY * _step;

  double get translationY => _startTranslationY + _incrementalTranslationY * _step;

  void update() {
    if (_step < _numSteps) {
      _step++;
    }
  }
}
