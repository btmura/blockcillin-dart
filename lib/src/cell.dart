part of client;

class Cell {

  Block block;

  Cell(this.block);

  factory Cell.withRandomBlock([int seed]) {
    return new Cell(new Block.withRandomColor(seed));
  }
}
