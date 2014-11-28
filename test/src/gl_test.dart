library gl;

import 'package:unittest/html_config.dart';
import 'package:unittest/unittest.dart';

import 'package:blockcillin/src/gl.dart';

const _vertexShaderSource = '''
  void main(void) {
    gl_Position = vec4(0.0, 0.0, 0.0, 0.0);    
  }
''';

const _fragmentShaderSource = '''
  precision mediump float;

  void main(void) {
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
  }
''';

var _gl;

main() {
  useHtmlConfiguration();

  group("gl", () {
    setUp(() {
      _gl = getWebGL("#canvas");
      expect(_gl, isNotNull);
    });

    test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - valid shaders", () {
      var program = createProgram(_gl, _vertexShaderSource, _fragmentShaderSource);
      expect(program, isNotNull);
    });

    test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - invalid vertex shader", () {
      var program = createProgram(_gl, "bad vertex shader source", _fragmentShaderSource);
      expect(program, isNull);
    });

    test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - invalid fragment shader", () {
      var program = createProgram(_gl, _vertexShaderSource, "bad fragment shader source");
      expect(program, isNull);
    });
  });
}
