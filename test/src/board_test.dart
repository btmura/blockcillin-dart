import 'package:unittest/unittest.dart';

import 'package:blockcillin/src/board.dart';
import 'package:blockcillin/src/ring.dart';

main() {
  group("Board", () {
    test("Board(rings)", () {
      var rings = [new Ring.withRandomCells(3), new Ring.withRandomCells(3)];
      var board = new Board(rings);
      expect(board.rings, equals(rings));
    });

    test("Board.withRandomRings(numRings, numCells)", () {
      var board = new Board.withRandomRings(3, 2);
      expect(board.rings.length, equals(3));
      expect(board.rings[0].cells.length, 2);
      expect(board.rings[1].cells.length, 2);
      expect(board.rings[2].cells.length, 2);
    });
  });
}
