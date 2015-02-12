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

  /// Pauses the game.
  bool pause() {
    return board.pause();
  }

  /// Resumes the game.
  bool resume() {
    return board.resume();
  }

  /// Signals to the game that it should stop.
  bool stop() {
    return board.stop();
  }
}
