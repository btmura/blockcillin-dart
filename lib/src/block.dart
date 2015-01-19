part of client;

/// Block of a certain color.
class Block {

  /// Number of unique indices in a block's index buffer.
  static const numIndices = 24;

  /// Indices of a block's index buffer.
  static const List<int> indices = const [
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
}

enum BlockColor {
  RED,
  GREEN,
  CYAN,
  PURPLE,
  YELLOW,
  BLUE,
}
