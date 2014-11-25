import 'dart:html';

import 'package:blockcillin/src/board.dart';
import 'package:blockcillin/src/game.dart';

main() {
  var board = new Board([]);
  var game = new Game(board);
  querySelector("#text").text = "Hello, blockcillin!";
}
