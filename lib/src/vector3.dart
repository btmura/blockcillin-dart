part of client;

class Vector3 {

  final Float32List storage;

  Vector3(double x, double y, double z) : storage = new Float32List(3) {
    storage[0] = x;
    storage[1] = y;
    storage[2] = z;
  }

  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];

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