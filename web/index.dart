import 'dart:html';

import 'package:blockcillin/src/game.dart';

main() {
  var game = new Game.withRandomBoard(3, 3);
  querySelector("#text").text = "Hello, blockcillin!";
}
