part of client;

class Quaternion {

  final Float32List floatList;

  Quaternion(double x, double y, double z, double w) : floatList = new Float32List(4) {
    floatList[0] = x;
    floatList[1] = y;
    floatList[2] = z;
    floatList[3] = w;
  }

  double get x => floatList[0];
  double get y => floatList[1];
  double get z => floatList[2];
  double get w => floatList[3];
}
