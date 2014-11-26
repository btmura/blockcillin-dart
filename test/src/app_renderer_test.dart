import 'package:unittest/html_config.dart';
import 'package:unittest/unittest.dart';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_renderer.dart';

main() {
  useHtmlConfiguration();

  group("AppRenderer", () {
    test("app", () {
      var app = new App();
      var appRenderer = new AppRenderer(app);
      expect(appRenderer.app, equals(app));
    });
  });
}
