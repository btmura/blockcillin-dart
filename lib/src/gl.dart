part of blockcillin;

webgl.RenderingContext getWebGL(CanvasElement canvas) {
  var gl = canvas.getContext("webgl");
  if (gl != null) {
    return gl;
  }

  gl = canvas.getContext("experimental-webgl");
  if (gl != null) {
    return gl;
  }

  print("gl: couldn't get rendering context");
  return null;
}

webgl.Program createProgram(webgl.RenderingContext gl, String vertexShaderSource, String fragmentShaderSource) {
  var vertexShader = _createShader(gl, webgl.VERTEX_SHADER, vertexShaderSource);
  var fragmentShader = _createShader(gl, webgl.FRAGMENT_SHADER, fragmentShaderSource);

  var program = gl.createProgram();
  gl
    ..attachShader(program, vertexShader)
    ..attachShader(program, fragmentShader)
    ..linkProgram(program);

  var linked = gl.getProgramParameter(program, webgl.LINK_STATUS);
  if (!linked) {
    var error = gl.getProgramInfoLog(program);
    gl.deleteProgram(program);
    throw new StateError("gl: error linking program: $error");
  }

  return program;
}

webgl.Shader _createShader(webgl.RenderingContext gl, int type, String source) {
  var shader = gl.createShader(type);
  gl
    ..shaderSource(shader, source)
    ..compileShader(shader);

  var compiled = gl.getShaderParameter(shader, webgl.COMPILE_STATUS);
  if (!compiled) {
    var error = gl.getShaderInfoLog(shader);
    gl.deleteShader(shader);
    throw new ArgumentError("gl: error compiling shader: $type $error");
  }

  return shader;
}

/// Creates a STATIC_DRAW array buffer with the data.
webgl.Buffer createArrayBuffer(webgl.RenderingContext gl, List<double> data) {
  var buffer = gl.createBuffer();
  gl
    ..bindBuffer(webgl.ARRAY_BUFFER, buffer)
    ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(data), webgl.STATIC_DRAW);
  return buffer;
}

/// Creates a STATIC_DRAW element array buffer with the data.
webgl.Buffer createElementArrayBuffer(webgl.RenderingContext gl, List<int> data) {
  var buffer = gl.createBuffer();
  gl
    ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, buffer)
    ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(data), webgl.STATIC_DRAW);
  return buffer;
}

/// Function that returns a uniform's location given a name.
typedef webgl.UniformLocation UniformLocator(String name);

/// Returns a UniformLocator that locates a uniform or throws an exception.
UniformLocator newUniformLocator(webgl.RenderingContext gl, webgl.Program program) {
  return (String name) {
    var location = gl.getUniformLocation(program, name);
    if (location == null) {
      throw new ArgumentError("${name} not found");
    }
    return location;
  };
}

/// Function that returns an attribute's location given a name.
typedef int AttribLocator(String name);

/// Returns an AttribLocator that locates an attribute or throws an exception.
AttribLocator newAttribLocator(webgl.RenderingContext gl, webgl.Program program) {
  return (String name) {
    var location = gl.getAttribLocation(program, name);
    if (location == -1) {
      throw new ArgumentError("${name} not found");
    }
    return location;
  };
}
