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

  /// Returns a list of vectors specifying the normals.
  static List<Vector3> getNormalVectors() {
    var frontNormal = new Vector3(0.0, 0.0, 1.0);
    var backNormal = new Vector3(0.0, 0.0, -1.0);
    var leftNormal = new Vector3(-1.0, 0.0, 0.0);
    var rightNormal = new Vector3(1.0, 0.0, 0.0);
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
    // TODO(btmura): create a Vector2 class
    // ul = (0, 0), br = (1, 1)
    var texturePoints = [
      // Front
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Back
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Left
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Right
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Top
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Bottom
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),
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

enum BlockColor {
  RED,
  GREEN,
  CYAN,
  PURPLE,
  YELLOW,
  BLUE,
}
