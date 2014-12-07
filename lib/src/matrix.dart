part of client;

class Matrix {

  final Float32List values;

  factory Matrix.rotationX(double radians) {
    var c = math.cos(radians);
    var s = math.sin(radians);
    return new Matrix.fromList([
      1.0, 0.0, 0.0, 0.0,
      0.0, c, s, 0.0,
      0.0, -s, c, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }

  factory Matrix.rotationY(double radians) {
    var c = math.cos(radians);
    var s = math.sin(radians);
    return new Matrix.fromList([
      c, 0.0, -s, 0.0,
      0.0, 1.0, 0.0, 0.0,
      s, 0.0, c, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }

  factory Matrix.rotationZ(double radians) {
    var c = math.cos(radians);
    var s = math.sin(radians);
    return new Matrix.fromList([
      c, s, 0.0, 0.0,
      -s, c, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }

  factory Matrix.fromList(List<double> elements) {
    return new Matrix._(new Float32List.fromList(elements));
  }

  Matrix._(this.values);
}