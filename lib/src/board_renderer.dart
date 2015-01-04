part of client;

class BoardRenderer {

  static final int _numRings = 10;
  static final int _numCells = 24;
  static final int _numTiles = 8;

  final GLProgram _glProgram;
  final webgl.Buffer _vertexBuffer;
  final webgl.Buffer _normalBuffer;
  final webgl.Buffer _textureBuffer;
  final webgl.Buffer _indexBuffer;

  factory BoardRenderer(GLProgram glProgram) {
    var gl = glProgram.gl;
    var program = glProgram.program;

    var outerRadius = 1.0;
    var innerRadius = 0.75;

    var outerVector = new Vector3(0.0, 0.0, outerRadius);
    var innerVector = new Vector3(0.0, 0.0, innerRadius);

    var yAxis = new Vector3(0.0, 1.0, 0.0);
    var halfSwing = new Quaternion.fromAxisAngle(yAxis, math.PI / _numCells);
    var cellRotation = new Quaternion.fromAxisAngle(yAxis, 2 * math.PI / _numCells);

    var outerSwingVector = halfSwing.rotate(outerVector);
    var innerSwingVector = halfSwing.rotate(innerVector);

    var outerX = outerSwingVector.x;
    var outerY = outerX;
    var outerZ = outerSwingVector.z;

    var innerX = innerSwingVector.x;
    var innerY = outerX;
    var innerZ = innerSwingVector.z;

    var ringTranslation = new Vector3(0.0, -outerX * 2, 0.0);

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
      outerUpperRight,
      outerUpperLeft,
      outerBottomLeft,
      outerBottomRight,

      // Back
      innerUpperLeft,
      innerUpperRight,
      innerBottomRight,
      innerBottomLeft,

      // Left
      outerUpperLeft,
      innerUpperLeft,
      innerBottomLeft,
      outerBottomLeft,

      // Right
      innerUpperRight,
      outerUpperRight,
      outerBottomRight,
      innerBottomRight,

      // Top
      innerUpperRight,
      innerUpperLeft,
      outerUpperLeft,
      outerUpperRight,

      // Bottom
      outerBottomRight,
      outerBottomLeft,
      innerBottomLeft,
      innerBottomRight,
    ];

    var frontNormal = new Vector3(0.0, 0.0, 1.0);
    var backNormal = new Vector3(0.0, 0.0, -1.0);
    var leftNormal = new Vector3(-1.0, 0.0, 0.0);
    var rightNormal = new Vector3(1.0, 0.0, 0.0);
    var topNormal = new Vector3(0.0, 1.0, 0.0);
    var bottomNormal = new Vector3(0.0, -1.0, 0.0);

    var normals = [
      // Front
      frontNormal,
      frontNormal,
      frontNormal,
      frontNormal,

      // Back
      backNormal,
      backNormal,
      backNormal,
      backNormal,

      // Left
      leftNormal,
      leftNormal,
      leftNormal,
      leftNormal,

      // Right
      rightNormal,
      rightNormal,
      rightNormal,
      rightNormal,

      // Top
      topNormal,
      topNormal,
      topNormal,
      topNormal,

      // Bottom
      bottomNormal,
      bottomNormal,
      bottomNormal,
      bottomNormal,
    ];

    var vertexData = [];
    var normalData = [];

    var totalRingTranslation = new Vector3(0.0, 0.0, 0.0);
    for (var i = 0; i < _numRings; i++) {
      var totalCellRotation = new Quaternion.fromAxisAngle(yAxis, 0.0);
      for (var j = 0; j < _numCells; j++) {
        for (var k = 0; k < vertices.length; k++) {
          var rotatedVertex = totalCellRotation.rotate(totalRingTranslation + vertices[k]);
          vertexData.add(rotatedVertex.x);
          vertexData.add(rotatedVertex.y);
          vertexData.add(rotatedVertex.z);

          var rotatedNormal = totalCellRotation.rotate(normals[k]);
          normalData.add(rotatedNormal.x);
          normalData.add(rotatedNormal.y);
          normalData.add(rotatedNormal.z);
        }
        totalCellRotation *= cellRotation;
      }
      totalRingTranslation += ringTranslation;
    }

    var vertexBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer)
      ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    var normalBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, normalBuffer)
      ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(normalData), webgl.STATIC_DRAW);

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
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Back
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Left
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Right
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Top
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),

      // Bottom
      new Vector3(1.0, 0.0, 0.0),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0),
      new Vector3(1.0, 1.0, 0.0),
    ];

    var random = new math.Random();
    var tileWidth = 1.0 / _numTiles;

    var textureData = [];
    for (var i = 0; i < _numRings; i++) {
      for (var j = 0; j < _numCells; j++) {
        var r = random.nextInt(_numTiles - 2);
        for (var k = 0; k < texturePoints.length; k++) {
          var p = texturePoints[k] * tileWidth;
          p.x += tileWidth * r;
          textureData.add(p.x);
          textureData.add(p.y);
        }
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
    for (var i = 0; i < _numRings; i++) {
      for (var j = 0; j < _numCells; j++) {
        for (var k = 0; k < indexPoints.length; k++) {
          indexData.add((i * 24 * _numCells) + (j * 24) + indexPoints[k]);
        }
      }
    }

    var indexBuffer = gl.createBuffer();
    gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer)
      ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);

    return new BoardRenderer._(glProgram, vertexBuffer, normalBuffer, textureBuffer, indexBuffer);
  }

  BoardRenderer._(this._glProgram, this._vertexBuffer, this._normalBuffer, this._textureBuffer, this._indexBuffer);

  void render(Board board) {
    var boardRotationMatrix = new Matrix4.rotation(0.0, board.rotationY, 0.0);
    var boardTranslationMatrix = new Matrix4.translation(0.0, board.translationY, 0.0);

    _glProgram.gl
      ..uniformMatrix4fv(_glProgram.boardRotationMatrixLocation, false, boardRotationMatrix.floatList)
      ..uniformMatrix4fv(_glProgram.boardTranslationMatrixLocation, false, boardTranslationMatrix.floatList);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
      ..enableVertexAttribArray(_glProgram.positionLocation)
      ..vertexAttribPointer(_glProgram.positionLocation, 3, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _normalBuffer)
      ..enableVertexAttribArray(_glProgram.normalLocation)
      ..vertexAttribPointer(_glProgram.normalLocation, 3, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _textureBuffer)
      ..enableVertexAttribArray(_glProgram.textureCoordLocation)
      ..vertexAttribPointer(_glProgram.textureCoordLocation, 2, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
      ..drawElements(webgl.TRIANGLES, 36 * _numRings * _numCells, webgl.UNSIGNED_SHORT, 0);
  }
}