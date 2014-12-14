part of client;

class Quaternion {

  final Float32List storage;

  Quaternion(double x, double y, double z, double w) : storage = new Float32List(4) {
    storage[0] = x;
    storage[1] = y;
    storage[2] = z;
    storage[3] = w;
  }

  factory Quaternion.fromAxisAngle(Vector3 axis, double angleRadians) {
    var halfSin = math.sin(angleRadians * 0.5) / axis.length;
    var x = axis.x * halfSin;
    var y = axis.y * halfSin;
    var z = axis.z * halfSin;
    var w = math.cos(angleRadians * 0.5);
    return new Quaternion(x, y, z, w);
  }

  factory Quaternion.fromVector(Vector3 v) {
    return new Quaternion(v.x, v.y, v.z, 0.0);
  }

  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];
  double get w => storage[3];

  Quaternion operator *(Quaternion o) {
    return new Quaternion(
        w * o.x + x * o.w + y * o.z - z * o.y,
        w * o.y + y * o.w + z * o.x - x * o.z,
        w * o.z + z * o.w + x * o.y - y * o.x,
        w * o.w - x * o.x - y * o.y - z * o.z);
  }

  Quaternion conjugate() {
    return new Quaternion(-x, -y, -z, w);
  }

  Vector3 rotate(Vector3 v) {
    var q = this * new Quaternion.fromVector(v) * conjugate();
    return new Vector3(q.x, q.y, q.z);
  }
}
