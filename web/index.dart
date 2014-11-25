import 'dart:html';

import 'package:blockcillin/src/game.dart';

main() {
  var g = new Game();
  querySelector("#text").text = g.text;
}