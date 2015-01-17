part of client;

class Cell {

  /// Block contained by cell. Could be null for an empty cell.
  Block block;

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
