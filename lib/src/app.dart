library app;

import 'package:blockcillin/src/game.dart';

class App {

  Game _game;

  App() {
    _game = new Game.withRandomBoard(3, 3);
  }
}
