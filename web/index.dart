import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_controller.dart';
import 'package:blockcillin/src/app_view.dart';
import 'package:blockcillin/src/game_view.dart';
import 'package:blockcillin/src/main_menu.dart';

main() {
  var app = new App();

  var mainMenu = new MainMenu();
  var gameView = new GameView.attached();
  var appView = new AppView(mainMenu, gameView);

  var appController = new AppController(app, appView);
  appController.run();
}
