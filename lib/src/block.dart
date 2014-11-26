library block;

import 'dart:math';

class Block {

  final BlockColor color;

  Block(this.color);

  factory Block.withRandomColor([int seed]) {
    return new Block(BlockColor.random(seed));
  }

  bool operator ==(o) => o is Block && o.color == color;

  toString() => "$color";
}

class BlockColor {

  static const red = const BlockColor._(0);
  static const blue = const BlockColor._(1);

  static const _allColors = const [red, blue];

  final int _value;

  const BlockColor._(this._value);

  static BlockColor random([int seed]) {
    var random = new Random(seed);
    var i = random.nextInt(_allColors.length);
    return _allColors[i];
  }

  toString() => "$_value";
}
