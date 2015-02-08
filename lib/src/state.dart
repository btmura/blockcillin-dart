part of client;

/// State function that advances the state and returns true if the state is still applicable.
typedef bool State();

/// A queue that manages different states of something.
class StateQueue {

  final List<State> _queue = [];

  /// Whether the queue is empty.
  bool get isEmpty => _queue.isEmpty;

  /// Adds a new state to the queue. It'll be applied after the other states have expired.
  void add(State state) {
    _queue.add(state);
  }

  /// Updates the queue by advancing the current state and removing that state if it has expired.
  /// Call this repeatedly to keep advancing the state of something.
  void update() {
    if (_queue.isNotEmpty && !_queue.first.call()) {
      _queue.removeAt(0);
    }
  }
}