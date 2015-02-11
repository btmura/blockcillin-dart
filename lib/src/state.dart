part of client;

/// A function that reevaluates the current state and returns true if we should remain in it.
typedef bool StateFunc();

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

  /// Adds a new state to the end of the queue.
  void add(State state) {
    _queue.add(state);
  }

  /// Returns whether the current state might have changed.
  bool update() {
    // Return false if there are no states to evaluate. Nothing will change.
    if (_queue.isEmpty) {
      return false;
    }

    // Reevaluate the current state. Remove it if it has expired.
    if (!_queue.first.func.call()) {
      _queue.removeAt(0);
    }

    // Return true because we revaluated the current state.
    return true;
  }

  /// Returns true if the queue contains any states with the given IDs.
  bool containsAny(List<int> ids) {
    return _queue.any((state) => ids.contains(state.id));
  }

  /// Removes any states that have the given ID.
  void remove(int id) {
    _queue.removeWhere((state) => id == state.id);
  }
}
