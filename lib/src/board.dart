part of client;

class Board {

  static const double _outerRadius = 1.0;
  static const double _innerRadius = 0.75;
  static const double _emptyRatio = 0.25;

  static const double _updatesPerState = 150.0;
  static const double _twistRotation = math.PI;

  static const double _initialRotationY = 0.0;
  static const double _initialTranslationY = -1.0;
  static const double _initialGrayscaleAmount = 1.0;
  static const double _initialBlackAmount = 1.0;
  static const double _pausedGrayscaleAmount = 1.0;
  static const double _pausedBlackAmount = 0.65;

  static final State _gameOverMarker = new State.marker("gm");
  static final State _pausedMarker = new State.marker("pm");
  static final State _finishedMarker = new State.marker("fm");

  final List<Ring> rings;
  final int numRings;
  final int numCells;
  final int numBlockColors;
  final double outerRadius = _outerRadius;
  final double innerRadius = _innerRadius;

  final StateQueue _stateQueue = new StateQueue();

  double _rotationY = _initialRotationY;
  double _translationY = _initialTranslationY;
  double _grayscaleAmount = _initialGrayscaleAmount;
  double _blackAmount = _initialBlackAmount;

  State _startTransition;
  State _playingState;
  State _gameOverTransition;
  State _pauseTransition;
  State _resumeTransition;
  State _finishTransition;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors) {
    _startTransition = _newStartTransition();
    _playingState = _newPlayingState();
    _gameOverTransition = _newGameOverTransition();
    _pauseTransition = _newPauseTransition();
    _resumeTransition = _newResumeTransition();
    _finishTransition = _newFinishTransition();

    _stateQueue
      ..add(_startTransition)
      ..add(_playingState)
      ..add(_gameOverTransition)
      ..add(_gameOverMarker);
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

  /// Returns whether the board changed after advancing it's state.
  bool update() {
    return _stateQueue.update();
  }

  /// Returns true if the request to pause was accepted.
  bool requestPause() {
    if (_stateQueue.isState(_playingState)) {
      _stateQueue
        ..clear()
        ..add(_pauseTransition)
        ..add(_pausedMarker);
      return true;
    }
    return false;
  }

  /// Returns true if the request to resume was accepted.
  bool requestResume() {
    if (_stateQueue.isState(_pausedMarker)) {
      _stateQueue
        ..clear()
        ..add(_resumeTransition)
        ..add(_playingState)
        ..add(_gameOverTransition)
        ..add(_gameOverMarker);
      return true;
    }
    return false;
  }

  /// Returns true if the request to finish was accepted.
  bool requestFinish() {
    if (_stateQueue.isState(_pausedMarker)) {
        _stateQueue
          ..clear()
          ..add(_finishTransition)
          ..add(_finishedMarker);
        return true;
    }
    return false;
  }

  State _newStartTransition() => new State.transition("st", _updatesPerState, (i) {
    var interp = _easeOutCubic(i, _updatesPerState);
    _rotationY = interp(_initialRotationY, _twistRotation);
    _translationY = interp(_initialTranslationY, 0.0);
    _grayscaleAmount = interp(_initialGrayscaleAmount, 0.0);
    _blackAmount = interp(_initialBlackAmount, 0.0);
  });

  State _newPlayingState() => new State.state("ps", () {
    _translationY += 0.001;
    return _translationY < 1.5;
  });

  State _newGameOverTransition() => new State.transition("gt", _updatesPerState, (i) {
    var interp = _easeOutCubic(i, _updatesPerState);
    _grayscaleAmount = interp(0.0, _pausedGrayscaleAmount);
    _blackAmount = interp(0.0, _pausedBlackAmount);
  });

  State _newPauseTransition() => new State.transition("ps", _updatesPerState, (i) {
    var interp = _easeOutCubic(i, _updatesPerState);
    _grayscaleAmount = interp(0.0, _pausedGrayscaleAmount);
    _blackAmount = interp(0.0, _pausedBlackAmount);
  });

  State _newResumeTransition() => new State.transition("rt", _updatesPerState, (i) {
    var interp = _easeOutCubic(i, _updatesPerState);
    _grayscaleAmount = interp(_pausedGrayscaleAmount, 0.0);
    _blackAmount = interp(_pausedBlackAmount, 0.0);
  });

  State _newFinishTransition() => () {
    var cr;
    var ct;
    return new State.transition("ft", _updatesPerState, (i) {
      var interp = _easeOutCubic(i, _updatesPerState);
      _rotationY = interp(cr, cr - _twistRotation);
      _translationY = interp(ct, ct - 1.0);
      _grayscaleAmount = interp(0.0, 1.0);
      _blackAmount = interp(0.0, 1.0);
    }, enter: () {
      cr = _rotationY;
      ct = _translationY;
    });
  }();
}
