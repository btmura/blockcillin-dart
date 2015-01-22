part of client;

/// A vector with 3 components: x, y, and z.
class Vector3 {

  /// Float list containing x, y, and z.
  final Float32List floatList;

  Vector3(double x, double y, double z) : floatList = new Float32List(3) {
    floatList[0] = x;
    floatList[1] = y;
    floatList[2] = z;
  }

  double get x => floatList[0];
  double get y => floatList[1];
  double get z => floatList[2];

  void set x(x) {
    floatList[0] = x;
  }

  void set y(y) {
    floatList[1] = y;
  }

  void set z(z) {
    floatList[2] = z;
  }

  double get length => math.sqrt(x * x + y * y + z * z);

  Vector3 operator +(Vector3 o) {
    return new Vector3(x + o.x, y + o.y, z + o.z);
  }

  Vector3 operator -(Vector3 o) {
    return new Vector3(x - o.x, y - o.y, z - o.z);
  }

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