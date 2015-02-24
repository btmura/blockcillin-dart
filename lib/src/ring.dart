part of blockcillin;

class Ring {

  List<Cell> cells;

  Ring(this.cells);

  factory Ring.withRandomCells(int numCells) {
    var cells = new List<Cell>(numCells);
    for (var i = 0; i < numCells; i++) {
      cells[i] = new Cell.withRandomBlock();
    }
    return new Ring(cells);
  }
}
