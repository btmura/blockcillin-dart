library app_controller;

import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_view.dart';

class AppController {

  final App app;
  final AppView appView;

  AppController(this.app, this.appView);

  void run() {
    window.onResize.listen((_) {
      appView.resizeCanvas();
    });

    appView.init();
    appView.draw();
  }
}
