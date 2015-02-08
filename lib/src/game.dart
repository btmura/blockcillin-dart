part of client;

class Game {

  /// Board with the blocks.
  final Board board;

  /// Whether the game is completely finished visually.
  bool _finished = false;

  Game(this.board);

  factory Game.withRandomBoard(int numRings, int numCells, int numBlockColors) {
    var board = new Board.withRandomRings(numRings, numCells, numBlockColors);
    return new Game(board);
  }

  /// Whether the game is completely finished visually.
  bool get finished {
    return _finished;
  }

  /// Advances the state of the game.
  void update() {
    board.update();
    _finished = board.cleared;
  }

  /// Signals to the game that it should start it's ending sequence.
  void finish() {
    board.clear();
  }
}
