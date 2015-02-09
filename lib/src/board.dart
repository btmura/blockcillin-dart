part of client;

class Board {

  /// Outer radius of the cylinder.
  static const double _outerRadius = 1.0;

  /// Inner radius of the cylinder.
  static const double _innerRadius = 0.75;

  static const double _emptyRatio = 0.25;

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

  /// How much of the color should be grayscale from 0.0 to 1.0.
  double _grayscaleAmount;

  /// How much of the color should be black from 0.0 to 1.0.
  double _blackAmount;

  /// Whether the board is being cleared for the next game.
  bool _clearing = false;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors) {
    _stateQueue
      ..add(_startState())
      ..add(_midState())
      ..add(_endState())
      ..add(_endState2());
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
  double get rotationY => _rotationY;

  /// Translation of the board on the y-axis.
  double get translationY => _translationY;

  /// How much of the color should be grayscale from 0.0 to 1.0.
  double get grayscaleAmount => _grayscaleAmount;

  /// How much of the color should be black from 0.0 to 1.0.
  double get blackAmount => _blackAmount;

  /// Whether the board has been cleared.
  bool get cleared => _stateQueue.isEmpty;

  /// Advances the state of the board.
  void update() {
    _stateQueue.update();
  }

  /// Clears the board meaning the player has decided to quit.
  void clear() {
    _clearing = true;
  }

  State _startState() {
    const int numSteps = 50;
    const double deltaRotationY = math.PI / 2.0 / numSteps;
    const double deltaTranslationY = 1.0 / numSteps;

    int i = 0;
    return () {
      if (i == 0) {
        _rotationY = 0.0;
        _translationY = -1.0;
        _grayscaleAmount = 0.0;
        _blackAmount = 0.0;
      } else {
        _rotationY += deltaRotationY;
        _translationY += deltaTranslationY;
      }
      return ++i < numSteps;
    };
  }

  State _midState() {
    return () {
      _translationY += 0.001;
      return !_clearing;
    };
  }

  State _endState() {
    const int numSteps = 25;
    const double deltaGrayscale = 1.0 / numSteps;

    int i = 0;
    return () {
      _grayscaleAmount += deltaGrayscale;
      return ++i < numSteps;
    };
  }

  State _endState2() {
    const int numSteps = 50;
    const double deltaRotationY = math.PI / 2.0 / numSteps;
    const double deltaTranslationY = 1.0 / numSteps;
    const double deltaBlack = 1.0 / numSteps;

    int i = 0;
    return () {
      _rotationY -= deltaRotationY;
      _translationY -= deltaTranslationY;
      _blackAmount += deltaBlack;
      return ++i < numSteps;
    };
  }
}