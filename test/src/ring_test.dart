part of tests;

ring_tests() {
  group("ring", () {
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
