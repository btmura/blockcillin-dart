part of client;

class Vector3 {

  final double x;
  final double y;
  final double z;

  Vector3(this.x, this.y, this.z);

  double get length => math.sqrt(x * x + y * y + z * z);

  Vector3 operator +(Vector3 o) {
    return new Vector3(x + o.x, y + o.y, z + o.z);
  }

  Vector3 operator -(Vector3 o) {
    return new Vector3(x - o.x, y - o.y, z - o.z);
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