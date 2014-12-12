part of client;

class Matrix4 {

  // TODO(btmura): add test for Matrix4

  final Float32List floatList;

  factory Matrix4.rotation(double radiansX, double radiansY, double radiansZ) {
    var x = new Matrix4.rotationX(radiansX);
    var y = new Matrix4.rotationY(radiansY);
    var z = new Matrix4.rotationZ(radiansZ);
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

  factory Matrix4.perspective(double fovRadians, double aspect, double near, double far) {
    var f = math.tan(math.PI * 0.5 - 0.5 * fovRadians);
    var rangeInv = 1.0 / (near - far);
    return new Matrix4.fromList([
        f / aspect, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (near + far) * rangeInv, -1.0,
        0.0, 0.0, near * far * rangeInv * 2.0, 0.0
    ]);
  }

  factory Matrix4.view(Vector3 cameraPosition, Vector3 target, Vector3 up) {
    var cameraMatrix = new Matrix4._lookAt(cameraPosition, target, up);
    return cameraMatrix.inverse();
  }

  factory Matrix4._lookAt(Vector3 cameraPosition, Vector3 target, Vector3 up) {
    var zAxis = (cameraPosition - target).normalize();
    var xAxis = up.cross(zAxis);
    var yAxis = zAxis.cross(xAxis);
    return new Matrix4.fromList([
      xAxis.x, xAxis.y, xAxis.z, 0.0,
      yAxis.x, yAxis.y, yAxis.z, 0.0,
      zAxis.x, zAxis.y, zAxis.z, 0.0,
      cameraPosition.x, cameraPosition.y, cameraPosition.z, 1.0
    ]);
  }

  factory Matrix4.fromList(List<double> elements) {
    return new Matrix4._(new Float32List.fromList(elements));
  }

  Matrix4._(this.floatList);

  double operator [](int i) => floatList[i];

  Matrix4 operator *(Matrix4 o) {
    var m = this;
    var n = o;
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

  Matrix4 inverse() {
    var m = this;
    var m00 = m[0 * 4 + 0];
    var m01 = m[0 * 4 + 1];
    var m02 = m[0 * 4 + 2];
    var m03 = m[0 * 4 + 3];
    var m10 = m[1 * 4 + 0];
    var m11 = m[1 * 4 + 1];
    var m12 = m[1 * 4 + 2];
    var m13 = m[1 * 4 + 3];
    var m20 = m[2 * 4 + 0];
    var m21 = m[2 * 4 + 1];
    var m22 = m[2 * 4 + 2];
    var m23 = m[2 * 4 + 3];
    var m30 = m[3 * 4 + 0];
    var m31 = m[3 * 4 + 1];
    var m32 = m[3 * 4 + 2];
    var m33 = m[3 * 4 + 3];
    var tmp_0  = m22 * m33;
    var tmp_1  = m32 * m23;
    var tmp_2  = m12 * m33;
    var tmp_3  = m32 * m13;
    var tmp_4  = m12 * m23;
    var tmp_5  = m22 * m13;
    var tmp_6  = m02 * m33;
    var tmp_7  = m32 * m03;
    var tmp_8  = m02 * m23;
    var tmp_9  = m22 * m03;
    var tmp_10 = m02 * m13;
    var tmp_11 = m12 * m03;
    var tmp_12 = m20 * m31;
    var tmp_13 = m30 * m21;
    var tmp_14 = m10 * m31;
    var tmp_15 = m30 * m11;
    var tmp_16 = m10 * m21;
    var tmp_17 = m20 * m11;
    var tmp_18 = m00 * m31;
    var tmp_19 = m30 * m01;
    var tmp_20 = m00 * m21;
    var tmp_21 = m20 * m01;
    var tmp_22 = m00 * m11;
    var tmp_23 = m10 * m01;

    var t0 = (tmp_0 * m11 + tmp_3 * m21 + tmp_4 * m31) -
      (tmp_1 * m11 + tmp_2 * m21 + tmp_5 * m31);
    var t1 = (tmp_1 * m01 + tmp_6 * m21 + tmp_9 * m31) -
      (tmp_0 * m01 + tmp_7 * m21 + tmp_8 * m31);
    var t2 = (tmp_2 * m01 + tmp_7 * m11 + tmp_10 * m31) -
      (tmp_3 * m01 + tmp_6 * m11 + tmp_11 * m31);
    var t3 = (tmp_5 * m01 + tmp_8 * m11 + tmp_11 * m21) -
      (tmp_4 * m01 + tmp_9 * m11 + tmp_10 * m21);

    var d = 1.0 / (m00 * t0 + m10 * t1 + m20 * t2 + m30 * t3);

    return new Matrix4.fromList([
      d * t0,
      d * t1,
      d * t2,
      d * t3,
      d * ((tmp_1 * m10 + tmp_2 * m20 + tmp_5 * m30) -
        (tmp_0 * m10 + tmp_3 * m20 + tmp_4 * m30)),
      d * ((tmp_0 * m00 + tmp_7 * m20 + tmp_8 * m30) -
        (tmp_1 * m00 + tmp_6 * m20 + tmp_9 * m30)),
      d * ((tmp_3 * m00 + tmp_6 * m10 + tmp_11 * m30) -
        (tmp_2 * m00 + tmp_7 * m10 + tmp_10 * m30)),
      d * ((tmp_4 * m00 + tmp_9 * m10 + tmp_10 * m20) -
        (tmp_5 * m00 + tmp_8 * m10 + tmp_11 * m20)),
      d * ((tmp_12 * m13 + tmp_15 * m23 + tmp_16 * m33) -
        (tmp_13 * m13 + tmp_14 * m23 + tmp_17 * m33)),
      d * ((tmp_13 * m03 + tmp_18 * m23 + tmp_21 * m33) -
        (tmp_12 * m03 + tmp_19 * m23 + tmp_20 * m33)),
      d * ((tmp_14 * m03 + tmp_19 * m13 + tmp_22 * m33) -
        (tmp_15 * m03 + tmp_18 * m13 + tmp_23 * m33)),
      d * ((tmp_17 * m03 + tmp_20 * m13 + tmp_23 * m23) -
        (tmp_16 * m03 + tmp_21 * m13 + tmp_22 * m23)),
      d * ((tmp_14 * m22 + tmp_17 * m32 + tmp_13 * m12) -
        (tmp_16 * m32 + tmp_12 * m12 + tmp_15 * m22)),
      d * ((tmp_20 * m32 + tmp_12 * m02 + tmp_19 * m22) -
        (tmp_18 * m22 + tmp_21 * m32 + tmp_13 * m02)),
      d * ((tmp_18 * m12 + tmp_23 * m32 + tmp_15 * m02) -
        (tmp_22 * m32 + tmp_14 * m02 + tmp_19 * m12)),
      d * ((tmp_22 * m22 + tmp_16 * m02 + tmp_21 * m12) -
        (tmp_20 * m12 + tmp_23 * m22 + tmp_17 * m02))
    ]);
  }
}