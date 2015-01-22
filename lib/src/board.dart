part of client;

class Board {

  static const int numStartSteps = 50;

  static const int numEndSteps = 200;

  /// Outer radius of the cylinder.
  static const double _outerRadius = 1.0;

  /// Inner radius of the cylinder.
  static const double _innerRadius = 0.75;

  static const double _emptyRatio = 0.5;

  static const double _startRotationY = 0.0;

  static const double _incrementalRotationY = math.PI / 2.0 / Board.numStartSteps;

  static const double _startTranslationY = -1.0;

  static const double _incrementalTranslationY = 1.0 / Board.numStartSteps;

  final List<Ring> rings;

  final int numRings;

  final int numCells;

  final int numBlockColors;

  final double outerRadius = _outerRadius;

  final double innerRadius = _innerRadius;

  bool _ending = false;

  bool done = false;

  int step = 0;

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

  void update() {
    if (step < numStartSteps || _ending && step < numEndSteps) {
      step++;
    }
    if (_ending) {
      if (step < numEndSteps) {
        for (var ring in rings) {
          for (var cell in ring.cells) {
            cell.positionOffset.y += 0.01;
            cell.positionOffsetChanged = true;
          }
        }
      }
      if (step == numEndSteps) {
        done = true;
      }
    }
  }

  double get rotationY {
    return _startRotationY + _incrementalRotationY * step;
  }

  double get translationY {
    return _startTranslationY + _incrementalTranslationY * step;
  }

  void end() {
    _ending = true;
  }
}
