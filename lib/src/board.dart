part of client;

class Board {

  /// Outer radius of the cylinder.
  static const double _outerRadius = 1.0;

  /// Inner radius of the cylinder.
  static const double _innerRadius = 0.75;

  /// Ration of how many blocks can be missing from each column.
  static const double _emptyRatio = 0.25;

  /// Number of update steps for each transition like pausing and resuming.
  static const double _numUpdates = 100.0;

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

  /// Rotation of the board around the y-axis.
  double get rotationY => _rotationY;

  /// Translation of the board on the y-axis.
  double get translationY => _translationY;

  /// How much of the color should be grayscale from 0.0 to 1.0.
  double get grayscaleAmount => _grayscaleAmount;

  /// How much of the color should be black from 0.0 to 1.0.
  double get blackAmount => _blackAmount;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors) {
    _stateQueue
      ..add(_startingState())
      ..add(_playingState());
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

  /// Returns whether the board changed after advancing it's state.
  bool update() {
    return _stateQueue.update();
  }

  /// Pauses the board.
  void pause() {
    // Pop off the infinite playing state before adding the pausing state.
    _stateQueue
      ..removeLast()
      ..add(_pausingState());
  }

  /// Resumes the board.
  void resume() {
    _stateQueue
      ..add(_resumingState())
      ..add(_playingState());
  }

  /// Clears the board meaning the player has decided to quit.
  // TODO(btmura): rename to finish to match method in game class.
  void clear() {
    _stateQueue.add(_clearingState());
  }

  StateFunc _startingState() {
    var i = 0.0;
    return () {
      var interp = _easeOutCubic(i, _numUpdates);
      _grayscaleAmount = interp(1.0, 0.0);
      _blackAmount = interp(1.0, 0.0);
      _rotationY = interp(0.0, math.PI);
      _translationY = interp(-1.0, 0.0);
      return ++i < _numUpdates;
    };
  }

  StateFunc _playingState() {
    return () {
      _translationY += 0.001;
      return true;
    };
  }

  StateFunc _pausingState() {
    var i = 0.0;
    var cg = _grayscaleAmount;
    var cb = _blackAmount;
    return () {
      var interp = _easeOutCubic(i, _numUpdates);
      _grayscaleAmount = interp(cg, 1.0);
      _blackAmount = interp(cb, 0.65);
      return ++i < _numUpdates;
    };
  }

  StateFunc _resumingState() {
    var i = 0.0;
    return () {
      var interp = _easeOutCubic(i, _numUpdates);
      _grayscaleAmount = interp(1.0, 0.0);
      _blackAmount = interp(0.65, 0.0);
      return ++i < _numUpdates;
    };
  }

  StateFunc _clearingState() {
    var i = 0.0;
    var cr = _rotationY;
    var ct = _translationY;
    return () {
      var interp = _easeOutCubic(i, _numUpdates);
      _grayscaleAmount = interp(0.0, 1.0);
      _blackAmount = interp(0.0, 1.0);
      _rotationY = interp(cr, cr - math.PI);
      _translationY = interp(ct, ct - 1.0);
      return ++i < _numUpdates;
    };
  }
}
