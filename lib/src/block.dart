class Block {

  final BlockColor color;

  Block(this.color);
}

class BlockColor {

  static const RED = const BlockColor._(0);
  static const BLUE = const BlockColor._(1);

  final int _value;

  const BlockColor._(this._value);
}
