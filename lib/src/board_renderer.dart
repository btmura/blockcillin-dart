part of client;

class BoardRenderer {

  /// Number of tiles per row in the single square texture.
  static const double _numTextureTiles = 8.0;

  /// Relative size of a single texture tile in the larger texture.
  static const double _textureTileSize = 1.0 / _numTextureTiles;

  static const double _startRotationY = 0.0;
  static const double _incrementalRotationY = math.PI / 2.0 / Board.numStartSteps;

  static const double _startTranslationY = -1.0;
  static const double _incrementalTranslationY = 1.0 / Board.numStartSteps;

  final GLProgram _glProgram;

  webgl.Buffer _vertexBuffer;
  webgl.Buffer _normalBuffer;
  webgl.Buffer _textureBuffer;
  webgl.Buffer _indexBuffer;

  BoardRenderer(this._glProgram);

  void init(Board board) {
    var gl = _glProgram.gl;

    var data = _getTextureAndNormalData(board);
    _vertexBuffer = createArrayBuffer(gl, data[0]);
    _normalBuffer = createArrayBuffer(gl, data[1]);

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

    _textureBuffer = createArrayBuffer(gl, _getTextureData(board));
    _indexBuffer = createElementArrayBuffer(gl, _getIndexData(board));
  }

  List<List<double>> _getTextureAndNormalData(Board board) {
    var outerRadius = 1.0;
    var innerRadius = 0.75;

    var outerVector = new Vector3(0.0, 0.0, outerRadius);
    var innerVector = new Vector3(0.0, 0.0, innerRadius);

    var yAxis = new Vector3(0.0, 1.0, 0.0);
    var halfSwing = new Quaternion.fromAxisAngle(yAxis, math.PI / board.numCells);
    var cellRotation = new Quaternion.fromAxisAngle(yAxis, 2 * math.PI / board.numCells);

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

    // Vector to translate cells out of the scene to make them appear empty.
    var emptyTranslation = new Vector3(100.0, 0.0, 0.0);

    var totalRingTranslation = new Vector3(0.0, 0.0, 0.0);
    for (var i = 0; i < board.numRings; i++) {
      var totalCellRotation = new Quaternion.fromAxisAngle(yAxis, 0.0);
      for (var j = 0; j < board.numCells; j++) {
        var cell = board.rings[i].cells[j];
        for (var k = 0; k < vertices.length; k++) {
          var rotatedVertex = totalCellRotation.rotate(totalRingTranslation + vertices[k]);
          if (cell.block == null) {
            rotatedVertex += emptyTranslation;
          }

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

    return [vertexData, normalData];
  }

  List<double> _getTextureData(Board board) {
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

    var flattenedPoints = [];
    for (var ring in board.rings) {
      for (var cell in ring.cells) {
        var colorIndex = cell.block != null ? cell.block.color.index : 0;
        for (var relPoint in texturePoints) {

          // Translate the relative point to absolute space.
          var absPoint = relPoint * _textureTileSize;

          // Move right to change colors relying on the image tiles.
          absPoint.x += colorIndex * _textureTileSize;

          flattenedPoints.add(absPoint.x);
          flattenedPoints.add(absPoint.y);
        }
      }
    }
    return flattenedPoints;
  }

  List<int> _getIndexData(Board board) {
    var indexData = [];
    for (var i = 0; i < board.numRings; i++) {
      for (var j = 0; j < board.numCells; j++) {
        indexData.addAll(Block.indices.map((index) {
          var offset = (i * board.numCells + j) * Block.numIndices;
          return offset + index;
        }));
      }
    }
    return indexData;
  }

  void render(Board board) {
    var rotationY = _startRotationY + _incrementalRotationY * board.step;
    var translationY = _startTranslationY + _incrementalTranslationY * board.step;

    var rotationMatrix = new Matrix4.rotation(0.0, rotationY, 0.0);
    var translationMatrix = new Matrix4.translation(0.0, translationY, 0.0);

    _glProgram.gl
      ..uniformMatrix4fv(_glProgram.boardRotationMatrixLocation, false, rotationMatrix.floatList)
      ..uniformMatrix4fv(_glProgram.boardTranslationMatrixLocation, false, translationMatrix.floatList);

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
      ..drawElements(webgl.TRIANGLES, 36 * board.numRings * board.numCells, webgl.UNSIGNED_SHORT, 0);
  }
}