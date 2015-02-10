part of client;

/// A function that reevaluates the current state and returns true if we should remain in it.
typedef bool StateFunc();

/// A queue that acts as a sequential finite state machine.
/// It is up to the caller to handle the logic of state transitions and enqueue states.
class StateQueue {

  final List<StateFunc> _queue = [];

  /// Adds a new state to the end of the queue.
  void add(StateFunc state) {
    _queue.add(state);
  }

  /// Returns whether the current state might have changed.
  bool update() {
    // Return false if there are no states to evaluate. Nothing will change.
    if (_queue.isEmpty) {
      return false;
    }

    // Reevaluate the current state. Remove it if it has expired.
    if (!_queue.first.call()) {
      _queue.removeAt(0);
    }

    // Return true because we revaluated the current state.
    return true;
  }

  /// Removes the last state in the queue. Good for breaking an infinitely looping state.
  void removeLast() {
    if (_queue.isNotEmpty) {
      _queue.removeLast();
    }
  }
}