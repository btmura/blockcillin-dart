library app_view;

import 'package:blockcillin/src/game_view.dart';
import 'package:blockcillin/src/main_menu.dart';

class AppView {

  final MainMenu mainMenu;
  final GameView gameView;

  AppView(this.mainMenu, this.gameView);

  factory AppView.append() {
    var mainMenu = new MainMenu();
    var gameView = new GameView.append();
    return new AppView(mainMenu, gameView);
  }

  void remove() {
    gameView.remove();
  }
}