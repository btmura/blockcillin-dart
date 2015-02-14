part of client;

class Board {

  /// Outer radius of the cylinder.
  static const double _outerRadius = 1.0;

  /// Inner radius of the cylinder.
  static const double _innerRadius = 0.75;

  /// Ration of how many blocks can be missing from each column.
  static const double _emptyRatio = 0.25;

  /// Number of update steps for each transition like pausing and resuming.
  static const double _updatesPerState = 75.0;

  /// Amount to rotate when starting and stopping.
  static const double _startStopRotation = math.PI;

  static const int _stateStarting = 0;
  static const int _statePlaying = 1;
  static const int _statePausing = 2;
  static const int _stateResuming = 3;
  static const int _stateStopping = 4;

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

  /// Returns true if the request to pause was accepted.
  bool requestPause() {
    if (_stateQueue.containsAny([_statePausing, _stateStopping])) {
      return false;
    }

    _stateQueue
      ..remove(_statePlaying)
      ..add(_pausingState());
    return true;
  }

  /// Returns true if the request to resume was accepted.
  bool requestResume() {
    if (_stateQueue.containsAny([_stateResuming, _stateStopping])) {
      return false;
    }

    _stateQueue
      ..add(_resumingState())
      ..add(_playingState());
    return true;
  }

  /// Returns true if the request to stop was accepted.
  bool requestStop() {
    if (_stateQueue.containsAny([_stateStopping])) {
      return false;
    }

    _stateQueue.add(_stoppingState());
    return true;
  }

  State _startingState() {
    var i = 0.0;
    return new State(_stateStarting, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(1.0, 0.0);
      _blackAmount = interp(1.0, 0.0);
      _rotationY = interp(0.0, _startStopRotation);
      _translationY = interp(-1.0, 0.0);
      return ++i < _updatesPerState;
    });
  }

  State _playingState() {
    return new State(_statePlaying, () {
      _translationY += 0.001;
      return true;
    });
  }

  State _pausingState() {
    var i = 0.0;
    var cg = _grayscaleAmount;
    var cb = _blackAmount;
    return new State(_statePausing, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(cg, 1.0);
      _blackAmount = interp(cb, 0.65);
      return ++i < _updatesPerState;
    });
  }

  State _resumingState() {
    var i = 0.0;
    return new State(_stateResuming, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(1.0, 0.0);
      _blackAmount = interp(0.65, 0.0);
      return ++i < _updatesPerState;
    });
  }

  State _stoppingState() {
    var i = 0.0;
    var cr = _rotationY;
    var ct = _translationY;
    return new State(_stateStopping, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(0.0, 1.0);
      _blackAmount = interp(0.0, 1.0);
      _rotationY = interp(cr, cr - _startStopRotation);
      _translationY = interp(ct, ct - 1.0);
      return ++i < _updatesPerState;
    });
  }
}
