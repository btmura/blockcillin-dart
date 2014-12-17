part of client;

class BoardRenderer {

  final GLProgram _glProgram;
  final webgl.Buffer _vertexBuffer;
  final webgl.Buffer _textureBuffer;
  final webgl.Buffer _indexBuffer;

  static final int numCells = 24;

  factory BoardRenderer(GLProgram glProgram) {
    var gl = glProgram.gl;
    var program = glProgram.program;

    var innerRadius = 0.75;
    var outerRadius = 1.0;

    var innerVector = new Vector3(0.0, 0.0, innerRadius);
    var outerVector = new Vector3(0.0, 0.0, outerRadius);

    var yAxis = new Vector3(0.0, 1.0, 0.0);
    var halfSwing = new Quaternion.fromAxisAngle(yAxis, math.PI / numCells);
    var fullSwing = new Quaternion.fromAxisAngle(yAxis, 2 * math.PI / numCells);

    var innerSwingVector = halfSwing.rotate(innerVector);
    var outerSwingVector = halfSwing.rotate(outerVector);

    var innerX = innerSwingVector.x;
    var innerY = innerX;
    var innerZ = innerSwingVector.z;

    var outerX = outerSwingVector.x;
    var outerY = outerX;
    var outerZ = outerSwingVector.z;

    Vector3 outerUpperRight = new Vector3(outerX, outerY, outerZ);
    Vector3 outerUpperLeft = new Vector3(-outerX, outerY, outerZ);

    Vector3 outerBottomLeft = new Vector3(-outerX, -outerY, outerZ);
    Vector3 outerBottomRight = new Vector3(outerX, -outerY, outerZ);

    Vector3 innerUpperLeft = new Vector3(-innerX, innerY, innerZ);
    Vector3 innerUpperRight = new Vector3(innerX, innerY, innerZ);

    Vector3 innerBottomRight = new Vector3(innerX, -innerY, innerZ);
    Vector3 innerBottomLeft = new Vector3(-innerX, -innerY, innerZ);

    // ur, ccw
    var vertices = [
      // Front
      outerUpperRight, outerUpperLeft, outerBottomLeft, outerBottomRight,

      // Back
      innerUpperLeft, innerUpperRight, innerBottomRight, innerBottomLeft,

      // Left
      outerUpperLeft, innerUpperLeft, innerBottomLeft, outerBottomLeft,

      // Right
      innerUpperRight, outerUpperRight, outerBottomRight, innerBottomRight,

      // Top
      innerUpperRight, innerUpperLeft, outerUpperLeft, outerUpperRight,

      // Bottom
      outerBottomRight, outerBottomLeft, innerBottomLeft, innerBottomRight,
    ];

    var cumulativeSwing = new Quaternion.fromAxisAngle(yAxis, 0.0);
    var vertexData = [];
    for (var i = 0; i < numCells; i++) {
      for (var j = 0; j < vertices.length; j++) {
        var vertex = cumulativeSwing.rotate(vertices[j]);
        vertexData.add(vertex.x);
        vertexData.add(vertex.y);
        vertexData.add(vertex.z);
      }
      cumulativeSwing *= fullSwing;
    }

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
    var texturePoints = [
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

      // Top
      1.0, 0.0,
      0.0, 0.0,
      0.0, 1.0,
      1.0, 1.0,

      // Bottom
      1.0, 0.0,
      0.0, 0.0,
      0.0, 1.0,
      1.0, 1.0,
    ];
    var textureData = [];
    for (var i = 0; i < numCells; i++) {
      for (var j = 0; j < texturePoints.length; j++) {
        textureData.add(texturePoints[j]);
      }
    }

    var textureBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, textureBuffer)
      ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(textureData), webgl.STATIC_DRAW);

    var indexPoints = [
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

      // Top
      16, 17, 18,
      18, 19, 16,

      // Bottom
      20, 21, 22,
      22, 23, 20,
    ];

    var indexData = [];
    for (var i = 0; i < numCells; i++) {
      for (var j = 0; j < indexPoints.length; j++) {
        indexData.add(indexPoints[j] + i * 24);
      }
    }

    var indexBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer)
      ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);

    return new BoardRenderer._(glProgram, vertexBuffer, textureBuffer, indexBuffer);
  }

  BoardRenderer._(this._glProgram, this._vertexBuffer, this._textureBuffer, this._indexBuffer);

  void render(Board board) {
    var boardRotationMatrix = new Matrix4.rotation(board.rotation[0], board.rotation[1], board.rotation[2]);

    _glProgram.gl
      ..uniformMatrix4fv(_glProgram.boardRotationMatrixLocation, false, boardRotationMatrix.floatList);

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
      ..drawElements(webgl.TRIANGLES, 36 * numCells, webgl.UNSIGNED_SHORT, 0);
  }
}