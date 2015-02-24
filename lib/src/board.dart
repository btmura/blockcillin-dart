part of blockcillin;

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
  static const double _pausedBlackAmount = 0.5;

  final List<Ring> rings;
  final int numRings;
  final int numCells;
  final int numBlockColors;
  final double outerRadius = _outerRadius;
  final double innerRadius = _innerRadius;

  final StateQueue _stateQueue = new StateQueue();
  final StreamController<AppState> _stateStream = new StreamController();

  double _rotationY = _initialRotationY;
  double _translationY = _initialTranslationY;
  double _grayscaleAmount = _initialGrayscaleAmount;
  double _blackAmount = _initialBlackAmount;

  State _startTransition;
  State _playingState;
  State _gameOverTransition;
  State _gameOverMarker;
  State _pauseTransition;
  State _pausedMarker;
  State _resumeTransition;
  State _finishTransition;
  State _finishedMarker;

  // TODO(btmura): change num of block colors to set of block colors
  Board(this.rings, this.numRings, this.numCells, this.numBlockColors) {
    _startTransition = _newStartTransition();
    _playingState = _newPlayingState();
    _gameOverTransition = _newFadeOutTransition("gt", AppState.GAME_OVERING);
    _gameOverMarker = _newMarker("gm", AppState.GAME_OVER);
    _pauseTransition = _newFadeOutTransition("pt", AppState.PAUSING);
    _pausedMarker = _newMarker("pm", AppState.PAUSED);
    _resumeTransition = _newFadeInTransition("rt", AppState.RESUMING);
    _finishTransition = _newFinishTransition();
    _finishedMarker = _newMarker("fm", AppState.FINISHED);

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

  /// Stream that broadcasts when the app's state has changed.
  Stream<AppState> get onAppStateChanged => _stateStream.stream;

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

  /// Requests the board to pause.
  void requestPause() {
    if (_stateQueue.isAt(_playingState)) {
      _stateQueue
        ..clear()
        ..add(_pauseTransition)
        ..add(_pausedMarker);
    }
  }

  /// Requests the board to resume.
  void requestResume() {
    if (_stateQueue.isAny([_pauseTransition, _pausedMarker])) {
      _stateQueue
        ..clear()
        ..add(_resumeTransition)
        ..add(_playingState)
        ..add(_gameOverTransition)
        ..add(_gameOverMarker);
    }
  }

  /// Requests the board to finish.
  void requestFinish() {
    if (_stateQueue.isAny([_pauseTransition, _pausedMarker, _gameOverMarker])) {
        _stateQueue
          ..clear()
          ..add(_finishTransition)
          ..add(_finishedMarker);
    }
  }

  State _newStartTransition() => new State.transition("st", _updatesPerState, (i) {
    var interp = _easeOutCubic(i, _updatesPerState);
    _rotationY = interp(_initialRotationY, _twistRotation);
    _translationY = interp(_initialTranslationY, 0.0);
    _grayscaleAmount = interp(_initialGrayscaleAmount, 0.0);
    _blackAmount = interp(_initialBlackAmount, 0.0);
  }, enter: () {
    _publishState(AppState.STARTING);
  });

  State _newPlayingState() => new State.state("ps", () {
      _translationY += 0.001;
      return _translationY < 1.5;
  }, enter: () {
    _publishState(AppState.PLAYING);
  });

  State _newFinishTransition() => () {
    var cr, ct, cg, cb;
    return new State.transition("ft", _updatesPerState, (i) {
      var interp = _easeOutCubic(i, _updatesPerState);
      _rotationY = interp(cr, cr - _twistRotation);
      _translationY = interp(ct, ct - 1.0);
      _grayscaleAmount = interp(cg, 1.0);
      _blackAmount = interp(cb, 1.0);
    }, enter: () {
      cr = _rotationY;
      ct = _translationY;
      cg = _grayscaleAmount;
      cb = _blackAmount;
      _publishState(AppState.FINISHING);
    });
  }();

  State _newFadeInTransition(String id, AppState state) => () {
    var cg, cb;
    return new State.transition(id, _updatesPerState, (i) {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(cg, 0.0);
      _blackAmount = interp(cb, 0.0);
    }, enter: () {
      cg = _grayscaleAmount;
      cb = _blackAmount;
      _publishState(state);
    });
  }();

  State _newFadeOutTransition(String id, AppState state) => () {
    var cg, cb;
    return new State.transition(id, _updatesPerState, (i) {
      var interp = _easeOutCubic(i, _updatesPerState);
      _grayscaleAmount = interp(cg, _pausedGrayscaleAmount);
      _blackAmount = interp(cb, _pausedBlackAmount);
    }, enter: () {
      cg = _grayscaleAmount;
      cb = _blackAmount;
      _publishState(state);
    });
  }();

  State _newMarker(String id, AppState state) => new State.marker(id, enter: () {
     _publishState(state);
  });

  void _publishState(AppState newState) {
    if (!_stateStream.isPaused) {
      _stateStream.add(newState);
    }
  }
}
