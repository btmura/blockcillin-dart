part of client;

class Game {

  final Board board;

  bool hasUpdates = true;

  Game(this.board);

  factory Game.withRandomBoard(int numRings, int numCells, int numBlockColors) {
    var board = new Board.withRandomRings(numRings, numCells, numBlockColors);
    return new Game(board);
  }

  void update() {
    board.update();
  }

  void end() {
    hasUpdates = false;
  }
}
