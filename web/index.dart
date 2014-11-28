import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_controller.dart';
import 'package:blockcillin/src/app_view.dart';

main() {
  var app = new App();
  var appView = new AppView();
  var appController = new AppController(app, appView);
  appController.run();
}
