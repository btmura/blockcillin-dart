import 'package:unittest/unittest.dart';

import 'package:blockcillin/src/cell.dart';
import 'package:blockcillin/src/ring.dart';

main() {
  group("Ring", () {
    test("Ring(cells)", () {
      var cells = [new Cell.withRandomBlock(), new Cell.withRandomBlock()];
      var ring = new Ring(cells);
      expect(ring.cells, equals(cells));
    });

    test("Ring.withRandomCells(numCells)", () {
      var ring = new Ring.withRandomCells(3);
      expect(ring.cells.length, equals(3));
    });
  });
}
