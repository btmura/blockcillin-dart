import 'package:blockcillin/src/board.dart';
import 'package:blockcillin/src/game.dart';
import 'package:unittest/unittest.dart';

main() {
  test("Game.board", () {
    var board = new Board([]);
    var game = new Game(board);
    expect(game.board, equals(board));
  });
}
