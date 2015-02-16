part of client;

class Game {

  /// Board with the blocks.
  final Board board;

  Game(this.board);

  factory Game.withRandomBoard(int numRings, int numCells, int numBlockColors) {
    var board = new Board.withRandomRings(numRings, numCells, numBlockColors);
    return new Game(board);
  }

  /// Returns whether the game changed after advancing it's state.
  bool update() {
    return board.update();
  }

  /// Returns true if the request to pause was accepted.
  bool requestPause() {
    return board.requestPause();
  }

  /// Returns true if the request to resume was accepted.
  bool requestResume() {
    return board.requestResume();
  }

  /// Returns true if the request to finish was accepted.
  bool requestFinish() {
    return board.requestFinish();
  }
}
