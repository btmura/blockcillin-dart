import 'dart:io';

import 'package:appengine/appengine.dart';

main() {
  runAppEngine((HttpRequest request) {
    if (request.uri.path == "/") {
      context.assets.serve("/index.html");
    } else {
      context.assets.serve();
    }
  });
}