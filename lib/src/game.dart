library game;

import 'package:blockcillin/src/board.dart';

class Game {

  final Board board;

  Game(this.board);

  factory Game.withRandomBoard(int numRings, int numCells) {
    var board = new Board.withRandomRings(numRings, numCells);
    return new Game(board);
  }
}