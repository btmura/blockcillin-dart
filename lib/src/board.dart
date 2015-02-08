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

  final StateQueue _stateQueue = new StateQueue();

  /// Rotation of the board around the y-axis.
  double _rotationY;

  /// Translation of the board on the y-axis.
  double _translationY;

  /// Whether the board is being cleared for the next game.
  bool _clearing = false;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors) {
    _stateQueue
      ..add(_newStartState())
      ..add(_newMidState())
      ..add(_newEndState());
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

  /// Rotation of the board around the y-axis.
  double get rotationY {
    return _rotationY;
  }

  /// Translation of the board on the y-axis.
  double get translationY {
    return _translationY;
  }

  /// Whether the board has been cleared.
  bool get cleared {
    return _stateQueue.isEmpty;
  }

  /// Advances the state of the board.
  void update() {
    _stateQueue.update();
  }

  /// Clears the board meaning the player has decided to quit.
  void clear() {
    _clearing = true;
  }

  State _newStartState() {
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
      return ++step < numSteps;
    };
  }

  State _newMidState() {
    return () {
      _translationY += 0.003;
      return !_clearing;
    };
  }

  State _newEndState() {
    const int numSteps = 150;
    const double deltaRotationY = math.PI / numSteps;
    const double deltaTranslationY = 1.0 / numSteps;

    int step = 0;

    return () {
      _rotationY += deltaRotationY;
      _translationY += deltaRotationY;

      for (var ring in rings) {
        for (var cell in ring.cells) {
          cell.positionOffset.y += 0.01;
          cell.positionOffsetChanged = true;
        }
      }

      return ++step < numSteps;
    };
  }
}