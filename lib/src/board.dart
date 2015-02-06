part of client;

class Board {

  /// Outer radius of the cylinder.
  static const double _outerRadius = 1.0;

  /// Inner radius of the cylinder.
  static const double _innerRadius = 0.75;

  static const double _emptyRatio = 0.5;

  final List<Ring> rings;

  final int numRings;
  final int numCells;
  final int numBlockColors;

  final double outerRadius = _outerRadius;
  final double innerRadius = _innerRadius;

  final List<State> _stateQueue = [];

  bool done = false;

  double _rotationY;
  double _translationY;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors) {
    _stateQueue.add(_newStartingGameState());
  }

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

  double get rotationY {
    return _rotationY;
  }

  double get translationY {
    return _translationY;
  }

  void update() {
    if (_stateQueue.isNotEmpty) {
      if (_stateQueue.first.call()) {
        _stateQueue.removeAt(0);
      }
    }
  }

  void end() {
    _stateQueue.add(_newEndingGameState());
  }

  State _newStartingGameState() {
    const int numSteps = 50;
    const double deltaRotationY = math.PI / 2.0 / numSteps;
    const double deltaTranslationY = 1.0 / numSteps;

    int step = 0;

    return () {
      if (step == 0) {
        _rotationY = 0.0;
        _translationY = -1.0;
      } else {
        _rotationY += deltaRotationY;
        _translationY += deltaTranslationY;
      }
      return ++step == numSteps;
    };
  }

  State _newEndingGameState() {
    const int numSteps = 150;

    int step = 0;

    return () {
      for (var ring in rings) {
        for (var cell in ring.cells) {
          cell.positionOffset.y += 0.01;
          cell.positionOffsetChanged = true;
        }
      }

      done = ++step == numSteps;
      return done;
    };
  }
}