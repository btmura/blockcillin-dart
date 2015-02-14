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

  static const int _startingState = 0;
  static const int _playingState = 1;
  static const int _pausingState = 2;
  static const int _pausedState = 3;
  static const int _resumingState = 4;
  static const int _stoppingState = 5;
  static const int _stoppedState = 6;

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
      ..add(_newStartingState())
      ..add(_newPlayingState());
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
    if (_stateQueue.isState(_playingState)) {
      _stateQueue
        ..removeFirst()
        ..add(_newPausingState())
        ..add(_newPausedState());
      return true;
    }
    return false;
  }

  /// Returns true if the request to resume was accepted.
  bool requestResume() {
    if (_stateQueue.isState(_pausedState)) {
      _stateQueue
        ..removeFirst()
        ..add(_newResumingState())
        ..add(_newPlayingState());
      return true;
    }
    return false;
  }

  /// Returns true if the request to stop was accepted.
  bool requestStop() {
    if (_stateQueue.isState(_pausedState)) {
        _stateQueue
          ..removeFirst()
          ..add(_newStoppingState())
          ..add(_newStoppedState());
        return true;
    }
    return false;
  }

  State _newStartingState() {
    var i = 0.0;
    return new State(_startingState, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(1.0, 0.0);
      _blackAmount = interp(1.0, 0.0);
      _rotationY = interp(0.0, _startStopRotation);
      _translationY = interp(-1.0, 0.0);
      return new StateResult(++i < _updatesPerState, true);
    });
  }

  State _newPlayingState() {
    return new State(_playingState, () {
      _translationY += 0.001;
      return StateResult.loop;
    });
  }

  State _newPausingState() {
    var i = 0.0;
    var cg = _grayscaleAmount;
    var cb = _blackAmount;
    return new State(_pausingState, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(cg, 1.0);
      _blackAmount = interp(cb, 0.65);
      return new StateResult(++i < _updatesPerState, true);
    });
  }

  State _newPausedState() {
    return new State(_pausedState, () {
      return StateResult.pause;
    });
  }

  State _newResumingState() {
    var i = 0.0;
    return new State(_resumingState, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(1.0, 0.0);
      _blackAmount = interp(0.65, 0.0);
      return new StateResult(++i < _updatesPerState, true);
    });
  }

  State _newStoppingState() {
    var i = 0.0;
    var cr = _rotationY;
    var ct = _translationY;
    return new State(_stoppingState, () {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(0.0, 1.0);
      _blackAmount = interp(0.0, 1.0);
      _rotationY = interp(cr, cr - _startStopRotation);
      _translationY = interp(ct, ct - 1.0);
      return new StateResult(++i < _updatesPerState, true);
    });
  }

  State _newStoppedState() {
    return new State(_stoppedState, () {
      return StateResult.pause;
    });
  }
}
