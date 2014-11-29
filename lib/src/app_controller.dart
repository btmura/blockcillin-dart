library app_controller;

import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_view.dart';

class AppController {

  final App app;
  final AppView appView;

  AppController(this.app, this.appView);

  void run() {
    _setupEventListeners();

    appView.init();

    _update();
  }

  void _setupEventListeners() {
    window.onResize.listen((_) {
      appView.resizeCanvas();
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
