part of blockcillin;

class Game {

  /// Board with the blocks.
  final Board board;

  Game(this.board);

  factory Game.withRandomBoard(int numRings, int numCells, int numBlockColors) {
    var board = new Board.withRandomRings(numRings, numCells, numBlockColors);
    return new Game(board);
  }

  /// Stream that broadcasts when the app's state has changed.
  Stream<AppState> get onAppStateChanged => board.onAppStateChanged;

  /// Returns whether the game changed after advancing it's state.
  bool update() {
    return board.update();
  }

  /// Requests the game to pause.
  void requestPause() {
    board.requestPause();
  }

  /// Requests the game to resume.
  void requestResume() {
    board.requestResume();
  }

  /// Requests the game to finish.
  void requestFinish() {
    board.requestFinish();
  }
}
