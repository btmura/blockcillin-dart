part of client;

class Fader {

  final Element _element;

  Function _fadeInStartCallback;
  Function _fadeOutEndCallback;

  StreamSubscription<TransitionEvent> _fadeInSubscription;
  StreamSubscription<TransitionEvent> _fadeOutSubscription;

  Fader(this._element);

  void set fadeInStartCallback(Function callback) {
    this._fadeInStartCallback = callback;
  }

  void set fadeOutEndCallback(Function callback) {
    this._fadeOutEndCallback = callback;
  }

  void set fade(bool fadeIn) {
    fadeIn ? _fadeIn() : _fadeOut();
  }

  void _fadeIn() {
    if (_fadeInSubscription == null) {
      if (_fadeOutSubscription != null) {
        _fadeOutSubscription.cancel();
        _fadeOutSubscription = null;
      }

      if (_fadeInStartCallback != null) {
        _fadeInStartCallback();
      }
      _fadeInSubscription = _element.onTransitionEnd.listen((_) {
      });

      _element.classes.add("fade-in");
      _element.classes.remove("fade-out");
    }
  }

  void _fadeOut() {
    if (_fadeOutSubscription == null) {
      if (_fadeInSubscription != null) {
        _fadeInSubscription.cancel();
        _fadeInSubscription = null;
      }

      _fadeOutSubscription = _element.onTransitionEnd.listen((_) {
        if (_fadeOutEndCallback != null) {
          _fadeOutEndCallback();
        }
      });

      _element.classes.remove("fade-in");
      _element.classes.add("fade-out");
    }
  }
}