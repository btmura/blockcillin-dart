library app_view;

import 'package:blockcillin/src/game_view.dart';
import 'package:blockcillin/src/main_menu.dart';

class AppView {

  final MainMenu mainMenu;
  final GameView gameView;

  AppView()
      : mainMenu = new MainMenu(),
        gameView = new GameView();

  bool init() {
    return gameView.init();
  }
}