part of blockcillin;

class Cell {

  /// Block contained by cell. Could be null for an empty cell.
  Block block;

  /// Position offset that should be added to the position to get the absolute position.
  Vector3 positionOffset = new Vector3(0.0, 0.0, 0.0);

  bool positionOffsetChanged = false;

  /// Creates a cell with a block of random color in it. Never empty.
  factory Cell.withRandomBlock([int seed]) {
    return new Cell(new Block.withRandomColor(seed));
  }

  /// Creates a cell without a block inside of it.
  factory Cell.empty() {
    return new Cell(null);
  }

  /// Creates a cell with a block. Used for testing.
  Cell(this.block);
}
