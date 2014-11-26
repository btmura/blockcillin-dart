library board;

import 'package:blockcillin/src/ring.dart';

class Board {

  final List<Ring> rings;

  Board(this.rings);

  factory Board.withRandomRings(int numRings, int numCells) {
    var rings = new List<Ring>(numRings);
    for (var i = 0; i < numRings; i++) {
      rings[i] = new Ring.withRandomCells(numCells);
    }
    return new Board(rings);
  }
}
