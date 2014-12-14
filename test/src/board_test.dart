part of test;

_board_tests() {
  group("board", () {
    test("Board", () {
      var rings = [new Ring.withRandomCells(3), new Ring.withRandomCells(3)];
      var board = new Board(rings);
      expect(board.rings, equals(rings));
    });

    test("Board.withRandomRings", () {
      var board = new Board.withRandomRings(3, 2);
      expect(board.rings.length, equals(3));
      expect(board.rings[0].cells.length, 2);
      expect(board.rings[1].cells.length, 2);
      expect(board.rings[2].cells.length, 2);
    });
  });
}
