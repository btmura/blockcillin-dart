part of client;

class Fader {

  final Element _element;

  Function onFadeInStartCallback;
  Function onFadeOutEndCallback;

  StreamSubscription<TransitionEvent> _fadeInSubscription;
  StreamSubscription<TransitionEvent> _fadeOutSubscription;

  Fader(this._element);

  void fadeIn() {
    if (_fadeInSubscription == null) {
      if (_fadeOutSubscription != null) {
        _fadeOutSubscription.cancel();
        _fadeOutSubscription = null;
      }

      if (onFadeInStartCallback != null) {
        onFadeInStartCallback();
      }
      _fadeInSubscription = _element.onTransitionEnd.listen((_) {
      });

      _element.classes.add("fade-in");
      _element.classes.remove("fade-out");
    }
  }

  void fadeOut() {
    if (_fadeOutSubscription == null) {
      if (_fadeInSubscription != null) {
        _fadeInSubscription.cancel();
        _fadeInSubscription = null;
      }

      _fadeOutSubscription = _element.onTransitionEnd.listen((_) {
        if (onFadeOutEndCallback != null) {
          onFadeOutEndCallback();
        }
      });

      _element.classes.remove("fade-in");
      _element.classes.add("fade-out");
    }
  }
}