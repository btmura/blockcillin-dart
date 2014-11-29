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

    window.onKeyUp.listen((event) {
      switch (event.keyCode) {
        case KeyCode.ESC:
          _mainMenu.show();
          break;
      }
    });

    _mainMenu.onNewGameButtonClick.listen((_) {
      _mainMenu.hide();
      appView.draw();
    });

    appView.init();
    _mainMenu.show();
  }
}
