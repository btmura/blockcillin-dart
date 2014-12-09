part of client;

class Matrix4 {

  final Float32List values;

  factory Matrix4.rotationXYZ(List<double> radians) {
    var x = new Matrix4.rotationX(radians[0]);
    var y = new Matrix4.rotationY(radians[1]);
    var z = new Matrix4.rotationZ(radians[2]);
    return x * y * z;
  }

  factory Matrix4.rotationX(double radians) {
    var c = math.cos(radians);
    var s = math.sin(radians);
    return new Matrix4.fromList([
      1.0, 0.0, 0.0, 0.0,
      0.0, c, s, 0.0,
      0.0, -s, c, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }

  factory Matrix4.rotationY(double radians) {
    var c = math.cos(radians);
    var s = math.sin(radians);
    return new Matrix4.fromList([
      c, 0.0, -s, 0.0,
      0.0, 1.0, 0.0, 0.0,
      s, 0.0, c, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }

  factory Matrix4.rotationZ(double radians) {
    var c = math.cos(radians);
    var s = math.sin(radians);
    return new Matrix4.fromList([
      c, s, 0.0, 0.0,
      -s, c, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }

  factory Matrix4.fromList(List<double> elements) {
    return new Matrix4._(new Float32List.fromList(elements));
  }

  Matrix4._(this.values);

  double operator [](int i) => values[i];

  Matrix4 operator *(Matrix4 other) {
    var m = this;
    var n = other;
    return new Matrix4.fromList([
      m[0]*n[0] + m[1]*n[4] + m[2]*n[8] + m[3]*n[12],
      m[0]*n[1] + m[1]*n[5] + m[2]*n[9] + m[3]*n[13],
      m[0]*n[2] + m[1]*n[6] + m[2]*n[10] + m[3]*n[14],
      m[0]*n[3] + m[1]*n[7] + m[2]*n[11] + m[3]*n[15],

      m[4]*n[0] + m[5]*n[4] + m[6]*n[8] + m[7]*n[12],
      m[4]*n[1] + m[5]*n[5] + m[6]*n[9] + m[7]*n[13],
      m[4]*n[2] + m[5]*n[6] + m[6]*n[10] + m[7]*n[14],
      m[4]*n[3] + m[5]*n[7] + m[6]*n[11] + m[7]*n[15],

      m[8]*n[0] + m[9]*n[4] + m[10]*n[8] + m[11]*n[12],
      m[8]*n[1] + m[9]*n[5] + m[10]*n[9] + m[11]*n[13],
      m[8]*n[2] + m[9]*n[6] + m[10]*n[10] + m[11]*n[14],
      m[8]*n[3] + m[9]*n[7] + m[10]*n[11] + m[11]*n[15],

      m[12]*n[0] + m[13]*n[4] + m[14]*n[8] + m[15]*n[12],
      m[12]*n[1] + m[13]*n[5] + m[14]*n[9] + m[15]*n[13],
      m[12]*n[2] + m[13]*n[6] + m[14]*n[10] + m[15]*n[14],
      m[12]*n[3] + m[13]*n[7] + m[14]*n[11] + m[15]*n[15]
    ]);
  }
}