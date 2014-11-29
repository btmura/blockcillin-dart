library app_controller;

import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_view.dart';
import 'package:blockcillin/src/main_menu.dart';

class AppController {

  final App app;
  final AppView appView;

  MainMenu _mainMenu;

  AppController(this.app, this.appView) {
    _mainMenu = new MainMenu();
  }

  void run() {
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

    _mainMenu.onNewGameButtonClick.listen((_) {
      app.gameStarted = true;
      app.gamePaused = false;
      _update();
    });

    appView.init();

    _update();
  }

  void _update() {
    if (!app.gameStarted || app.gamePaused) {
      _mainMenu.show();
    } else {
      _mainMenu.hide();
    }
  }
}
