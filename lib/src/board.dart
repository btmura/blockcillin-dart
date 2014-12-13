part of client;

class Board {

  final List<Ring> rings;
  final List<double> rotation = [0.0, 0.0, 0.0];

  Board(this.rings);

  factory Board.withRandomRings(int numRings, int numCells) {
    var rings = new List<Ring>(numRings);
    for (var i = 0; i < numRings; i++) {
      rings[i] = new Ring.withRandomCells(numCells);
    }
    return new Board(rings);
  }

  void update() {
    rotation[1] += math.PI / 400;
  }
}
