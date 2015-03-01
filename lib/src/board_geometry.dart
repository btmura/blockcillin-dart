part of blockcillin;

class BoardGeometry {

  final double outerRadius;
  final double innerRadius;
  final int ringCellCount;
  double theta;
  Vector3 outerVector;
  Vector3 outerBlockLeftVector;
  Vector3 outerBlockRightVector;

  BoardGeometry(this.outerRadius, this.innerRadius, this.ringCellCount) {
    theta = 2 * math.PI / ringCellCount;
    outerVector = new Vector3(0.0, 0.0, outerRadius);

    var leftSwing = new Quaternion.fromAxisAngle(_yAxis, -theta);
    outerBlockLeftVector = leftSwing.rotate(outerVector);

    var rightSwing = new Quaternion.fromAxisAngle(_yAxis, theta);
    outerBlockRightVector = rightSwing.rotate(outerVector);
  }
}
