part of client;

class Board {

  static const double _emptyRatio = 0.5;

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
    var random = new math.Random();

    // Randomly pick cells to vertically pluck from each column.
    var maxEmpty = (numRings * _emptyRatio).round();
    var emptyPerColumn = new List<int>.generate(numCells, (_) => random.nextInt(maxEmpty));

    var rings = new List<Ring>(numRings);
    for (var i = 0; i < numRings; i++) {
      var cells = new List<Cell>(numCells);
      for (var j = 0; j < numCells; j++) {
        cells[j] = i < emptyPerColumn[j] ? new Cell.empty() : new Cell.withRandomBlock();
      }
      rings[i] = new Ring(cells);
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
