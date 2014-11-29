library gl;

import 'dart:html';
import 'dart:web_gl' as webgl;

webgl.RenderingContext getWebGL(CanvasElement canvas) {
  var gl = canvas.getContext("webgl");
  if (gl != null) {
    return gl;
  }

  gl = canvas.getContext("experimental-webgl");
  if (gl != null) {
    return gl;
  }

  return null;
}

webgl.Program createProgram(webgl.RenderingContext gl, String vertexShaderSource, String fragmentShaderSource) {
  var vertexShader = _createShader(gl, webgl.VERTEX_SHADER, vertexShaderSource);
  if (vertexShader == null) {
    return null;
  }

  var fragmentShader = _createShader(gl, webgl.FRAGMENT_SHADER, fragmentShaderSource);
  if (fragmentShader == null) {
    return null;
  }

  var program = gl.createProgram();
  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);
  gl.linkProgram(program);

  var linked = gl.getProgramParameter(program, webgl.LINK_STATUS);
  if (!linked) {
    var error = gl.getProgramInfoLog(program);
    print("error linking program: $error");
    gl.deleteProgram(program);
    return null;
  }

  return program;
}

webgl.Shader _createShader(webgl.RenderingContext gl, int type, String source) {
  var shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  var compiled = gl.getShaderParameter(shader, webgl.COMPILE_STATUS);
  if (!compiled) {
    var error = gl.getShaderInfoLog(shader);
    print("error compiling shader: $type $error");
    gl.deleteShader(shader);
    return null;
  }

  return shader;
}
