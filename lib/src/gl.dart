part of blockcillin;

/// Returns the GL context from a canvas or null if not supported.
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

/// Returns a program created from vertex and fragment shader source code or throws an exception.
webgl.Program createProgram(webgl.RenderingContext gl, String vertexShader, String fragmentShader) {
  var vs = _createShader(gl, webgl.VERTEX_SHADER, vertexShader);
  var fs = _createShader(gl, webgl.FRAGMENT_SHADER, fragmentShader);

  var program = gl.createProgram();
  gl.attachShader(program, vs);
  gl.attachShader(program, fs);
  gl.linkProgram(program);

  if (!gl.getProgramParameter(program, webgl.LINK_STATUS)) {
    var error = gl.getProgramInfoLog(program);
    gl.deleteProgram(program);
    throw new StateError("gl: error linking program: $error");
  }

  return program;
}

/// Returns a shader created from a type and source code or throws an exception.
webgl.Shader _createShader(webgl.RenderingContext gl, int type, String source) {
  var shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, webgl.COMPILE_STATUS)) {
    var error = gl.getShaderInfoLog(shader);
    gl.deleteShader(shader);
    throw new ArgumentError("gl: error compiling shader: $type $error");
  }

  return shader;
}

/// Returns a STATIC_DRAW array buffer filled with data.
webgl.Buffer newArrayBuffer(webgl.RenderingContext gl, List<double> data) {
  var buffer = gl.createBuffer();
  gl.bindBuffer(webgl.ARRAY_BUFFER, buffer);
  gl.bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(data), webgl.STATIC_DRAW);
  return buffer;
}

/// Returns a STATIC_DRAW element array buffer filled with data.
webgl.Buffer newElementArrayBuffer(webgl.RenderingContext gl, List<int> data) {
  var buffer = gl.createBuffer();
  gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, buffer);
  gl.bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(data), webgl.STATIC_DRAW);
  return buffer;
}

/// Binds a buffer to a vertex attribute with 2 floats per vertex.
void enableVertexAttribArray2f(webgl.RenderingContext gl, webgl.Buffer buffer, int attribLocation) {
  gl.bindBuffer(webgl.ARRAY_BUFFER, buffer);
  gl.enableVertexAttribArray(attribLocation);
  gl.vertexAttribPointer(attribLocation, 2, webgl.FLOAT, false, 0, 0);
}

/// Binds a buffer to a vertex attribute with 3 floats per vertex.
void enableVertexAttribArray3f(webgl.RenderingContext gl, webgl.Buffer buffer, int attribLocation) {
  gl.bindBuffer(webgl.ARRAY_BUFFER, buffer);
  gl.enableVertexAttribArray(attribLocation);
  gl.vertexAttribPointer(attribLocation, 3, webgl.FLOAT, false, 0, 0);
}

/// Disables a vertex attribute array.
void disableVertexAttribArray(webgl.RenderingContext gl, int attribLocation) {
  gl.disableVertexAttribArray(attribLocation);
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

void drawTriangles(webgl.RenderingContext gl, webgl.Buffer indexBuffer, int triangleCount) {
    gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(webgl.TRIANGLES, triangleCount, webgl.UNSIGNED_SHORT, 0);
}
