part of client;

class Block {

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
