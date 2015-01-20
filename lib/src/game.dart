part of client;

class Game {

  /// Board with the blocks.
  final Board board;

  /// Done meaning the game has finished its ending sequence.
  bool done = false;

  Game(this.board);

  factory Game.withRandomBoard(int numRings, int numCells, int numBlockColors) {
    var board = new Board.withRandomRings(numRings, numCells, numBlockColors);
    return new Game(board);
  }

  void update() {
    board.update();
  }

  /// Signals to the game that it should start it's ending sequence.
  void end() {
    done = true;
  }
}
