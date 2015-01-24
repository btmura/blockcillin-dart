part of client;

/// A vector with x and y components.
class Vector2 {

  /// Float list with x and y.
  final Float32List floatList;

  /// Constructs a vector from x and y values.
  Vector2(double x, double y) : floatList = new Float32List(2) {
    floatList[0] = x;
    floatList[1] = y;
  }

  /// x component of the vector.
  double get x => floatList[0];

  /// y component of the vector.
  double get y => floatList[1];

  void set x(double x) {
    floatList[0] = x;
  }

  void set y(double y) {
    floatList[1] = y;
  }

  /// Multiplies the vector by a scalar. Returns a new Vector2 instance.
  Vector2 operator *(double scalar) {
    return new Vector2(x * scalar, y * scalar);
  }

  /// Prints out the x and y values.
  String toString() => "($x, $y)";
}