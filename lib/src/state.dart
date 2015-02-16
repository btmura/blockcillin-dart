part of client;

/// A queue that acts as a sequential finite state machine.
/// It is up to the caller to handle the logic of state transitions and enqueue states.
class StateQueue {

  final List<State> _queue = [];

  bool _enterCalled = false;

  /// Adds a new state to the end of the queue.
  void add(State state) {
    _queue.add(state);
  }

  /// Clears the entire queue.
  void clear() {
    _queue.clear();
    _enterCalled = false;
  }

  /// Returns whether the state has changed and the view should be updated.
  bool update() {
    if (_queue.isEmpty) {
      return false;
    }

    if (!_enterCalled) {
      _queue.first._enter.call();
      _enterCalled = true;
    }

    var result = _queue.first._update.call();
    if (!result._keepInQueue) {
      _queue.removeAt(0);
      _enterCalled = false;
    }

    return result._refreshView;
  }

  /// Returns true if the current state is the given one.
  bool inState(State state) {
    return _queue.isNotEmpty && _queue.first._id == state._id;
  }
}

/// A function that is called when entering a transition.
/// Use this to initialize variables that will be updated on each update.
typedef void TransitionEnterFunc();

/// A function that is called to update a transition.
/// It passes the current update to the caller.
typedef void TransitionUpdateFunc(double u);

/// A function that is called to update a state.
/// Returns true if the state is dirty an the view should be updated.
typedef bool StateUpdateFunc();

/// A state with an ID and StateFunc.
class State {

  final String _id;
  final Function _enter;
  final Function _update;

  State._(this._id, this._enter, this._update);

  /// Constructs a transition that occurs over updateCount number frames.
  /// Transitions make the view refresh itself for updateCount number of frames.
  factory State.transition(String id, double updateCount, TransitionUpdateFunc update, {TransitionEnterFunc enter}) {
    var i = 0.0;

    var wrappedEnter = () {
      if (enter != null) {
        enter();
      }
      i = 0.0;
    };

    var wrappedUpdate = () {
      update(i);
      return new _StateResult.transition(++i < updateCount);
    };

    return new State._(id, wrappedEnter, wrappedUpdate);
  }

  /// Constructs a state that continues until the update function returns false.
  /// States make the view refresh itself while the update function returns true.
  factory State.state(String id, StateUpdateFunc update) {
    return new State._(id, () {}, () => new _StateResult.transition(update()));
  }

  /// Constructs a marker that must be removed manually via the StateQueue.
  /// Markers do not make the view refresh. They are used to check what the current state is.
  factory State.marker(String id) {
    return new State._(id, () {}, () => new _StateResult.marker());
  }

  String toString() => "${_id}";
}

class _StateResult {

  final bool _keepInQueue;
  final bool _refreshView;

  _StateResult(this._keepInQueue, this._refreshView);

  factory _StateResult.transition(bool refreshView) {
    return new _StateResult(refreshView, true);
  }

  factory _StateResult.marker() {
    return new _StateResult(true, false);
  }
}
