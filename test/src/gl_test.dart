import 'package:blockcillin/src/gl.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

main() {
  useHtmlConfiguration();

  var gl = getWebGL("#canvas");
  expect(gl, isNotNull);

  var vertexShaderSource = '''
      void main(void) {
        gl_Position = vec4(0.0, 0.0, 0.0, 0.0);    
      }
    ''';

  var fragmentShaderSource = '''
      precision mediump float;
  
      void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    ''';

  test("createProgram(gl, vertexShaderSource, fragmentShaderSource)", () {
    var program = createProgram(gl, vertexShaderSource, fragmentShaderSource);
    expect(program, isNotNull);
  });

  test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - bad vertex shader source", () {
    var program = createProgram(gl, "bad vertex shader source", fragmentShaderSource);
    expect(program, isNull);
  });

  test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - bad fragment shader source", () {
    var program = createProgram(gl, vertexShaderSource, "bad fragment shader source");
    expect(program, isNull);
  });
}
