part of test;

_game_tests() {
  group("game", () {
    test("Game", () {
      var board = new Board.withRandomRings(2, 1);
      var game = new Game(board);
      expect(game.board, equals(board));
    });

    test("Game.withRandomBoard", () {
      var game = new Game.withRandomBoard(2, 1);
      expect(game.board.rings.length, equals(2));
      expect(game.board.rings[0].cells.length, equals(1));
      expect(game.board.rings[1].cells.length, equals(1));
    });
  });
}
