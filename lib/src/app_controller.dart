library app_controller;

import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_view.dart';

class AppController {

  final App app;
  final AppView appView;

  AppController()
      : app = new App(),
        appView = new AppView();

  void run() {
    if (appView.init()) {
      _setupStreams();
      _update();
    }
  }

  void _setupStreams() {
    window.onResize.listen((_) {
      appView.gameView.resize();
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
  }
}
