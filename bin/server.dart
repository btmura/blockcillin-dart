import 'dart:io';

import 'package:appengine/appengine.dart';

main() {
  runAppEngine((HttpRequest request) {
    if (request.uri.path == "/favicon.ico") {
     context.assets.serve();   
    } else {
      request.response..write('Hello, blockcillin!')
                      ..close();
    }
  });
}