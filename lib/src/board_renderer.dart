part of client;

class BoardRenderer {

  final GLProgram _glProgram;
  final webgl.Buffer _vertexBuffer;
  final webgl.Buffer _textureBuffer;
  final webgl.Buffer _indexBuffer;

  factory BoardRenderer(GLProgram glProgram) {
    var gl = glProgram.gl;
    var program = glProgram.program;

    // ur, ccw
    var vertexData = [
        // Front
        0.5, 0.5, 0.5,
        -0.5, 0.5, 0.5,
        -0.5, -0.5, 0.5,
        0.5, -0.5, 0.5,

        // Back
        -0.5, 0.5, -0.5,
        0.5, 0.5, -0.5,
        0.5, -0.5, -0.5,
        -0.5, -0.5, -0.5,

        // Left
        -0.5, 0.5, 0.5,
        -0.5, 0.5, -0.5,
        -0.5, -0.5, -0.5,
        -0.5, -0.5, 0.5,

        // Right
        0.5, 0.5, -0.5,
        0.5, 0.5, 0.5,
        0.5, -0.5, 0.5,
        0.5, -0.5, -0.5,
    ];
    var vertexBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer)
      ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    var texture = gl.createTexture();
    var green = [0, 255, 0, 255];
    gl
      ..bindTexture(webgl.TEXTURE_2D, texture)
      ..texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, 1, 1, 0, webgl.RGBA, webgl.UNSIGNED_BYTE, new Uint8List.fromList(green));

    var image = new ImageElement(src: "packages/blockcillin/texture.png");
    image.onLoad.listen((_) {
      gl
        ..bindTexture(webgl.TEXTURE_2D, texture)
        ..texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA, webgl.UNSIGNED_BYTE, image)
        ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR)
        ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR_MIPMAP_NEAREST)
        ..generateMipmap(webgl.TEXTURE_2D);
    });

    // ul = (0, 0), br = (1, 1)
    var textureData = [
        // Front
        1.0, 0.0,
        0.0, 0.0,
        0.0, 1.0,
        1.0, 1.0,

        // Back
        1.0, 0.0,
        0.0, 0.0,
        0.0, 1.0,
        1.0, 1.0,

        // Left
        1.0, 0.0,
        0.0, 0.0,
        0.0, 1.0,
        1.0, 1.0,

        // Right
        1.0, 0.0,
        0.0, 0.0,
        0.0, 1.0,
        1.0, 1.0,
    ];
    var textureBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, textureBuffer)
      ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(textureData), webgl.STATIC_DRAW);

    var indexData = [
        // Front
        0, 1, 2,
        2, 3, 0,

        // Back
        4, 5, 6,
        6, 7, 4,

        // Left
        8, 9, 10,
        10, 11, 8,

        // Right
        12, 13, 14,
        14, 15, 12,
    ];
    var indexBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer)
      ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);


    return new BoardRenderer._(glProgram, vertexBuffer, textureBuffer, indexBuffer);
  }

  BoardRenderer._(this._glProgram, this._vertexBuffer, this._textureBuffer, this._indexBuffer);

  void render(Board board) {
    var boardRotationMatrix = new Matrix.rotationX(board.rotation[0]);

    _glProgram.gl
      ..uniformMatrix4fv(_glProgram.boardRotationMatrixLocation, false, boardRotationMatrix.values);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
      ..enableVertexAttribArray(_glProgram.positionLocation)
      ..vertexAttribPointer(_glProgram.positionLocation, 3, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _textureBuffer)
      ..enableVertexAttribArray(_glProgram.textureCoordLocation)
      ..vertexAttribPointer(_glProgram.textureCoordLocation, 2, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
      ..drawElements(webgl.TRIANGLES, 24, webgl.UNSIGNED_SHORT, 0);
  }
}