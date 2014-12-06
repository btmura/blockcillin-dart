part of client;

class BoardRenderer {

  final webgl.RenderingContext _gl;
  final webgl.Program _program;
  final int _positionLocation;
  final int _textureCoordLocation;

  final webgl.Buffer _vertexBuffer;
  final webgl.Buffer _textureBuffer;
  final webgl.Buffer _indexBuffer;

  factory BoardRenderer(GLProgram glProgram) {
    var gl = glProgram.gl;
    var program = glProgram.program;

    var vertexData = [
        -0.5, -0.5, 0.0,
        -0.5, 0.5, 0.0,
        0.5, 0.5, 0.0,
        0.5, -0.5, 0.0,
    ];
    var vertexBuffer = gl.createBuffer();
    gl
        ..bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer)
        ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    var texture = gl.createTexture();
    var green = [0, 255, 0, 255];
    gl.bindTexture(webgl.TEXTURE_2D, texture);
    gl.texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, 1, 1, 0, webgl.RGBA, webgl.UNSIGNED_BYTE, new Uint8List.fromList(green));

    var textureData = [
        1, 0,
        0, 0,
        0, 1,
        1, 1,
    ];
    var textureBuffer = gl.createBuffer();
    gl
        ..bindBuffer(webgl.ARRAY_BUFFER, textureBuffer)
        ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(textureData), webgl.STATIC_DRAW);

    var indexData = [
        0, 1, 2,
        0, 2, 3,
    ];
    var indexBuffer = gl.createBuffer();
    gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer)
        ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);


    return new BoardRenderer._(gl, program, glProgram.positionLocation, glProgram.textureCoordLocation, vertexBuffer, textureBuffer, indexBuffer);
  }

  BoardRenderer._(this._gl, this._program, this._positionLocation, this._textureCoordLocation, this._vertexBuffer, this._textureBuffer, this._indexBuffer);

  void render(Board board) {
    _gl
        ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
        ..enableVertexAttribArray(_positionLocation)
        ..vertexAttribPointer(_positionLocation, 3, webgl.FLOAT, false, 0, 0);

    _gl
        ..bindBuffer(webgl.ARRAY_BUFFER, _textureBuffer)
        ..enableVertexAttribArray(_textureCoordLocation)
        ..vertexAttribPointer(_textureCoordLocation, 2, webgl.FLOAT, false, 0, 0);

    _gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
        ..drawElements(webgl.TRIANGLES, 6, webgl.UNSIGNED_SHORT, 0);
  }
}