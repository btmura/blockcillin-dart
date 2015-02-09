part of client;

/// A function that interpolates from start value to end value.
typedef double InterpolateFunc(double start, double end);

/// Returns an InterpolateFunc that eases out cubically.
InterpolateFunc _easeOutCubic(double time, double duration) {
  return (double start, double end) {
    var delta = end - start;
    var t = time / duration - 1;
    return start + delta * (t * t * t + 1);
  };
}