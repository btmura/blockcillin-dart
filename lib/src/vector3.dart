part of blockcillin;

/// A vector with x, y, and z components.
class Vector3 {

  /// Float list with x, y, and z.
  final Float32List floatList;

  /// Constructs a vector from x, y, and z values.
  Vector3(double x, double y, double z) : floatList = new Float32List(3) {
    floatList[0] = x;
    floatList[1] = y;
    floatList[2] = z;
  }

  /// x component of the vector.
  double get x => floatList[0];

  /// y component of the vector.
  double get y => floatList[1];

  /// z component of the vector.
  double get z => floatList[2];

  void set x(double x) {
    floatList[0] = x;
  }

  void set y(double y) {
    floatList[1] = y;
  }

  void set z(double z) {
    floatList[2] = z;
  }

  double get length => math.sqrt(x * x + y * y + z * z);

  Vector3 operator +(Vector3 o) {
    return new Vector3(x + o.x, y + o.y, z + o.z);
  }

  Vector3 operator -(Vector3 o) {
    return new Vector3(x - o.x, y - o.y, z - o.z);
  }

  /// Multiplies the vector by a scalar. Returns a new Vector3 instance.
  Vector3 operator *(double scalar) {
    return new Vector3(x * scalar, y * scalar, z * scalar);
  }

  bool operator ==(o) => o is Vector3 && o.x == x && o.y == y && o.z == z;

  Vector3 cross(Vector3 o) {
    return new Vector3(
        y * o.z - z * o.y,
        z * o.x - x * o.z,
        x * o.y - y * o.x);
  }

  Vector3 normalize() {
    var l = length;
    if (l > 0.00001) {
      return new Vector3(x / l, y / l, z / l);
    }
    return new Vector3(0.0, 0.0, 0.0);
  }

  String toString() => "($x, $y, $z)";
}