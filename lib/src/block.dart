part of client;

/// Block of a certain color.
class Block {

  /// Number of tiles per row in the single square texture.
  static const double _numTextureTiles = 8.0;

  /// Relative size of a single texture tile in the larger texture.
  static const double _textureTileSize = 1.0 / _numTextureTiles;

  /// Number of unique indices in a block's index buffer.
  static const numIndices = 24;

  /// Color of the block.
  final BlockColor color;

  Block(this.color);

  factory Block.withRandomColor([int seed]) {
    var random = new math.Random(seed);
    var colors = BlockColor.values;
    var index = random.nextInt(colors.length);
    return new Block(colors[index]);
  }

  bool operator ==(o) => o is Block && o.color == color;

  toString() => "$color";

  /// Returns a list of vectors specifying the block's vertices.
  static List<Vector3> getVertexVectors(double outerRadius, double innerRadius, double theta) {
    var outerVector = new Vector3(0.0, 0.0, outerRadius);
    var innerVector = new Vector3(0.0, 0.0, innerRadius);

    var yAxis = new Vector3(0.0, 1.0, 0.0);
    var halfSwing = new Quaternion.fromAxisAngle(yAxis, theta / 2);

    var outerSwingVector = halfSwing.rotate(outerVector);
    var innerSwingVector = halfSwing.rotate(innerVector);

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
    return [
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
  }

  /// Returns a list of vectors specifying the block's normals.
  static List<Vector3> getNormalVectors(double theta) {
    var yAxis = new Vector3(0.0, 1.0, 0.0);
    var halfSwingLeft = new Quaternion.fromAxisAngle(yAxis, -theta / 2);
    var halfSwingRight = new Quaternion.fromAxisAngle(yAxis, theta / 2);

    var zAxis = new Vector3(0.0, 0.0, 1.0);
    var vectorSwungLeft = halfSwingLeft.rotate(zAxis);
    var vectorSwungRight = halfSwingRight.rotate(zAxis);

    var leftNormal = vectorSwungLeft.cross(yAxis).normalize();
    var rightNormal = yAxis.cross(vectorSwungRight).normalize();

    var frontNormal = new Vector3(0.0, 0.0, 1.0);
    var backNormal = new Vector3(0.0, 0.0, -1.0);
    var topNormal = new Vector3(0.0, 1.0, 0.0);
    var bottomNormal = new Vector3(0.0, -1.0, 0.0);

    return [
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
  }

  /// Returns a flattened texture coordinate list to draw a block of some color.
  static List<double> getTextureData(BlockColor color) {
    // ul = (0, 0), br = (1, 1)
    var texturePoints = [
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

    var data = [];
    for (var relPoint in texturePoints) {
      // Translate the relative point to absolute space.
      var absPoint = relPoint * _textureTileSize;

      // Move right to change colors relying on the image tiles.
      absPoint.x += color.index * _textureTileSize;

      data.add(absPoint.x);
      data.add(absPoint.y);
    }
    return data;
  }

  /// Returns a list of indices to draw the block.
  static List<int> getIndexData() {
    return const [
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

      // Top+
      16, 17, 18,
      18, 19, 16,

      // Bottom
      20, 21, 22,
      22, 23, 20,
    ];
  }
}

/// Color of a block.
class BlockColor {

  static const BlockColor RED = const BlockColor._(0);

  static const BlockColor GREEN = const BlockColor._(1);

  static const BlockColor CYAN = const BlockColor._(2);

  static const BlockColor PURPLE = const BlockColor._(3);

  static const BlockColor YELLOW = const BlockColor._(4);

  static const BlockColor BLUE = const BlockColor._(5);

  static const List<BlockColor> values = const [
    RED,
    GREEN,
    CYAN,
    PURPLE,
    YELLOW,
    BLUE
  ];

  final int index;

  const BlockColor._(this.index);
}