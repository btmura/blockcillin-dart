import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_renderer.dart';

main() {
  var app = new App();
  var appRenderer = new AppRenderer(app);
  appRenderer.render();
}
