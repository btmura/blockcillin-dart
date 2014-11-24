import 'dart:io';

import 'package:appengine/appengine.dart';

main() {
  runAppEngine((HttpRequest request) {
    request.response..write('Hello, world!')
                    ..close();
  });
}