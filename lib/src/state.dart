part of client;

/// A result of calling a StateFunc.
class StateResult {

  /// A State that stay in the queue and cause the game loop to keep going.
  static final StateResult loop = new StateResult(true, true);

  /// A State that stay in the queue but can pause the game loop.
  static final StateResult pause = new StateResult(true, false);

  /// Whether we should remain in this state.
  final bool stay;

  /// Whether the view should be updated to reflect changes.
  final bool dirty;

  StateResult(this.stay, this.dirty);
}

/// A function that reevaluates the current state and returns a StateResult.
typedef StateResult StateFunc();

/// A state with an ID and StateFunc.
class State {

  /// Numerical ID used to identify this state.
  final int id;

  /// Function used to evaluate the state.
  final StateFunc func;

  State(this.id, this.func);
}

/// A queue that acts as a sequential finite state machine.
/// It is up to the caller to handle the logic of state transitions and enqueue states.
class StateQueue {

  final List<State> _queue = [];

  /// Returns whether the state is dirty and the view should be updated.
  bool update() {
    if (_queue.isEmpty) {
      return false;
    }

    var result = _queue.first.func.call();
    if (!result.stay) {
      _queue.removeAt(0);
    }

    return result.dirty;
  }

  /// Adds a new state to the end of the queue.
  void add(State state) {
    _queue.add(state);
  }

  /// Removes the state at the front of the queue.
  void removeFirst() {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0);
    }
  }

  /// Returns true if the current state's id is the given one.
  bool isState(int id) {
    return _queue.isNotEmpty && _queue.first.id == id;
  }
}
