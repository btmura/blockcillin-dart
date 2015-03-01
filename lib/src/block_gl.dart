part of blockcillin;

/// GL-related code to render a block.
class BlockGL {

  /// Number of unique indices in a block's index buffer.
  static const uniqueIndexCount = 24;

  /// Number of indices in the block's index buffer.
  static const indexCount = 36;

  final List<Vector3> vertices;
  final List<Vector3> normals;
  final List<int> indices;

  final Quaternion cellRotation;
  final Vector3 ringTranslation;

  factory BlockGL(double outerRadius, double innerRadius, int cellsPerRing) {
    var theta = 2 * math.PI / cellsPerRing;
    var halfSwing = new Quaternion.fromAxisAngle(_yAxis, theta / 2);

    var outerVector = new Vector3(0.0, 0.0, outerRadius);
    var innerVector = new Vector3(0.0, 0.0, innerRadius);

    var outerSwingVector = halfSwing.rotate(outerVector);
    var innerSwingVector = halfSwing.rotate(innerVector);

    var cellRotation = new Quaternion.fromAxisAngle(_yAxis, theta);
    var ringTranslation = new Vector3(0.0, -outerSwingVector.x * 2, 0.0);

    var outerX = outerSwingVector.x;
    var outerY = outerX;
    var outerZ = outerSwingVector.z;

    var innerX = innerSwingVector.x;
    var innerY = outerX;
    var innerZ = innerSwingVector.z;

    var outerUpperRight = new Vector3(outerX, outerY, outerZ);
    var outerUpperLeft = new Vector3(-outerX, outerY, outerZ);

    var outerBottomLeft = new Vector3(-outerX, -outerY, outerZ);
    var outerBottomRight = new Vector3(outerX, -outerY, outerZ);

    var innerUpperLeft = new Vector3(-innerX, innerY, innerZ);
    var innerUpperRight = new Vector3(innerX, innerY, innerZ);

    var innerBottomRight = new Vector3(innerX, -innerY, innerZ);
    var innerBottomLeft = new Vector3(-innerX, -innerY, innerZ);

    // ur, ccw
    var vertices = [
      // Front
      outerUpperRight,
      outerUpperLeft,
      outerBottomLeft,
      outerBottomRight,

      // Back
      innerUpperLeft,
      innerUpperRight,
      innerBottomRight,
      innerBottomLeft,

      // Left
      outerUpperLeft,
      innerUpperLeft,
      innerBottomLeft,
      outerBottomLeft,

      // Right
      innerUpperRight,
      outerUpperRight,
      outerBottomRight,
      innerBottomRight,

      // Top
      innerUpperRight,
      innerUpperLeft,
      outerUpperLeft,
      outerUpperRight,

      // Bottom
      outerBottomRight,
      outerBottomLeft,
      innerBottomLeft,
      innerBottomRight,
    ];

    var halfSwingLeft = new Quaternion.fromAxisAngle(_yAxis, -theta / 2);
    var halfSwingRight = new Quaternion.fromAxisAngle(_yAxis, theta / 2);

    var vectorSwungLeft = halfSwingLeft.rotate(_zAxis);
    var vectorSwungRight = halfSwingRight.rotate(_zAxis);

    var leftNormal = vectorSwungLeft.cross(_yAxis).normalize();
    var rightNormal = _yAxis.cross(vectorSwungRight).normalize();

    var frontNormal = new Vector3(0.0, 0.0, 1.0);
    var backNormal = new Vector3(0.0, 0.0, -1.0);
    var topNormal = new Vector3(0.0, 1.0, 0.0);
    var bottomNormal = new Vector3(0.0, -1.0, 0.0);

    var normals = [
      // Front
      frontNormal,
      frontNormal,
      frontNormal,
      frontNormal,

      // Back
      backNormal,
      backNormal,
      backNormal,
      backNormal,

      // Left
      leftNormal,
      leftNormal,
      leftNormal,
      leftNormal,

      // Right
      rightNormal,
      rightNormal,
      rightNormal,
      rightNormal,

      // Top
      topNormal,
      topNormal,
      topNormal,
      topNormal,

      // Bottom
      bottomNormal,
      bottomNormal,
      bottomNormal,
      bottomNormal,
    ];

    var indices = const [
      // Front
      0, 1, 2,
      2, 3, 0,

      // Back
      4, 5, 6,
      6, 7, 4,

      // Left
      8, 9, 10,
      10, 11, 8,

      // Right
      12, 13, 14,
      14, 15, 12,

      // Top
      16, 17, 18,
      18, 19, 16,

      // Bottom
      20, 21, 22,
      22, 23, 20,
    ];

    return new BlockGL._(vertices, normals, indices, cellRotation, ringTranslation);
  }

  BlockGL._(this.vertices, this.normals, this.indices, this.cellRotation, this.ringTranslation);

  List<Vector2> getTextureCoords(BlockColor color) {
    // ul = (0, 0), br = (1, 1)
    var textureCoords = [
      // Front
      new Vector2(1.0, 0.0),
      new Vector2(0.0, 0.0),
      new Vector2(0.0, 1.0),
      new Vector2(1.0, 1.0),

      // Back
      new Vector2(1.0, 0.0),
      new Vector2(0.0, 0.0),
      new Vector2(0.0, 1.0),
      new Vector2(1.0, 1.0),

      // Left
      new Vector2(1.0, 0.0),
      new Vector2(0.0, 0.0),
      new Vector2(0.0, 1.0),
      new Vector2(1.0, 1.0),

      // Right
      new Vector2(1.0, 0.0),
      new Vector2(0.0, 0.0),
      new Vector2(0.0, 1.0),
      new Vector2(1.0, 1.0),

      // Top
      new Vector2(1.0, 0.0),
      new Vector2(0.0, 0.0),
      new Vector2(0.0, 1.0),
      new Vector2(1.0, 1.0),

      // Bottom
      new Vector2(1.0, 0.0),
      new Vector2(0.0, 0.0),
      new Vector2(0.0, 1.0),
      new Vector2(1.0, 1.0),
    ];

    return _toTextureTileCoords(textureCoords, color.index, 0);
  }
}
