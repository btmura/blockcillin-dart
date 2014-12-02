library app_controller;

import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_view.dart';
import 'package:blockcillin/src/game.dart';

class AppController {

  final App app;
  final AppView appView;

  AppController(this.app, this.appView);

  void run() {
    _init();
    _update();
  }

  void _init() {
    appView.gameView.resize();

    window.onResize.listen((_) {
      if (appView.gameView.resize()) {
        _update();
      }
    });

    window.onKeyUp
        .where((event) => event.keyCode == KeyCode.ESC)
        .listen((_) {
          if (app.gameStarted) {
            app.gamePaused = !app.gamePaused;
            _update();
          }
        });

    appView.mainMenu.onNewGameButtonClick.listen((_) {
      app.gameStarted = true;
      app.gamePaused = false;
      app.game = new Game.withRandomBoard(3, 3);
      _update();
    });

    appView.gameView.buttonBar.onPauseButtonClick.listen((_) {
      app.gamePaused = true;
      _update();
    });
  }

  void _update() {
    appView.mainMenu.visible = !app.gameStarted || app.gamePaused;
    appView.gameView.buttonBar.visible = app.gameStarted && !app.gamePaused;
    if (app.game != null) {
      appView.gameView.draw(app.game);
    }
  }

  void detach() {
    appView.detach();
  }
}
