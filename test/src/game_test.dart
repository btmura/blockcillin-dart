part of tests;

game_tests() {
  group("game", () {
    test("Game(board)", () {
      var board = new Board.withRandomRings(2, 1);
      var game = new Game(board);
      expect(game.board, equals(board));
    });

    test("Game.withRandomBoard(numRings, numCells)", () {
      var game = new Game.withRandomBoard(2, 1);
      expect(game.board.rings.length, equals(2));
      expect(game.board.rings[0].cells.length, equals(1));
      expect(game.board.rings[1].cells.length, equals(1));
    });
  });
}
