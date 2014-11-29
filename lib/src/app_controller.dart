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
    appView.gameView.setup();
    _setupStreams();
    _update();
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
  }

  void _update() {
    appView.mainMenu.visible = !app.gameStarted || app.gamePaused;
  }
}
